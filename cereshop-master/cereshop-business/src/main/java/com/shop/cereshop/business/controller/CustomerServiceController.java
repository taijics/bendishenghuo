package com.shop.cereshop.business.controller;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.shop.cereshop.business.dao.customer_service.CereShopCustomerServiceDAO;
import com.shop.cereshop.business.param.customer_service.CustomerServiceAuthState;
import com.shop.cereshop.business.utils.ContextUtil;
import com.shop.cereshop.commons.constant.CoReturnFormat;
import com.shop.cereshop.commons.constant.WxCpConstants;
import com.shop.cereshop.commons.domain.customer_service.CereCustomerService;
import com.shop.cereshop.commons.domain.customer_service.CereCustomerServiceReceptionist;
import com.shop.cereshop.commons.domain.customer_service.ShopCustomerService;
import com.shop.cereshop.commons.exception.CoBusinessException;
import com.shop.cereshop.commons.result.Result;
import com.shop.cereshop.commons.utils.TimeUtils;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import me.chanjar.weixin.common.error.WxErrorException;
import me.chanjar.weixin.cp.api.WxCpUserService;
import me.chanjar.weixin.cp.api.impl.WxCpServiceImpl;
import me.chanjar.weixin.cp.bean.WxCpDepart;
import me.chanjar.weixin.cp.bean.WxCpUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 客服
 */
@RestController
@RequestMapping("customerService")
/**
 * 注解方式生成日志对象，指定topic生成对象类名
 */
@Slf4j(topic = "CustomerServiceController")
@Api(value = "客服模块", tags = "客服模块")
public class CustomerServiceController {

    @Autowired
    private CereShopCustomerServiceDAO cereShopCustomerServiceDAO;

    @Autowired
    private WxCpServiceImpl wxCpServiceImpl;

    @Autowired
    private WxCpUserService wxCpUserService;

    @PostMapping("checkAuthState")
    @ApiOperation("检查是否已授权")
    public Result<CustomerServiceAuthState> checkAuthState(HttpServletRequest request) throws Exception {
        CustomerServiceAuthState authState = new CustomerServiceAuthState();
        authState.setState(2);
        return new Result<>(authState);
    }

    @PostMapping("getAll")
    @ApiOperation("查询客服列表")
    public Result<List<CereCustomerService>> getAll(HttpServletRequest request) {
        try {
            List<CereCustomerService> resultList = new ArrayList<>();
            Long shopId = ContextUtil.getShopId();
            List<ShopCustomerService> serviceList = cereShopCustomerServiceDAO
                    .selectList(Wrappers.<ShopCustomerService>lambdaQuery().eq(ShopCustomerService::getShopId, shopId));
            if (CollectionUtils.isEmpty(serviceList)) {
                return new Result<>(Collections.emptyList());
            }

            List<String> kfIdList = serviceList.stream().map(ShopCustomerService::getOpenKfid).collect(Collectors.toList());
            String result = wxCpServiceImpl.get(WxCpConstants.API_KF_LIST, "access_token=" + getAccessToken(request));
            JSONObject obj = JSON.parseObject(result);
            if (obj != null) {
                JSONArray array = obj.getJSONArray("account_list");
                if (array != null) {
                    for (int i=0;i<array.size();i++) {
                        JSONObject item = array.getJSONObject(i);
                        CereCustomerService service = new CereCustomerService();
                        String kfId = item.getString("open_kfid");
                        if (!kfIdList.contains(kfId)) {
                            continue;
                        }
                        String name = item.getString("name");
                        String avatar = item.getString("avatar");
                        service.setOpenKfId(kfId);
                        service.setKfId(kfId);
                        service.setName(name);
                        service.setHeadImg(avatar);
                        service.setUrl(WxCpConstants.API_KF_URL + kfId);

                        JSONObject kfParamObj = new JSONObject();
                        kfParamObj.put("open_kfid", kfId);
                        String kfUrlResult = wxCpServiceImpl.post(WxCpConstants.API_ADD_CONTACT_WAY, kfParamObj.toJSONString());
                        if (kfUrlResult != null) {
                            JSONObject kfUrlItem = JSON.parseObject(kfUrlResult);
                            String url = kfUrlItem.getString("url");
                            service.setUrl(url);
                            int startIndex = url.indexOf("/kfid/");
                            int markIndex = url.indexOf("?");
                            if (markIndex == -1) {
                                markIndex = url.length();
                            }
                            service.setKfId(url.substring(startIndex + 6, markIndex));
                        }

                        resultList.add(service);
                    }
                }
            }
            return new Result<>(resultList);
        } catch(Exception e) {
            log.error("getAll: " + e.getMessage(), e);
        }
        return new Result<>(Collections.emptyList());
    }


    @PostMapping("save")
    @ApiOperation("新增客服")
    public Result<Integer> save(@RequestBody CereCustomerService param, HttpServletRequest request) {
        int result = 0;
        try {
            JSONObject obj = new JSONObject();
            obj.put("name", param.getName());
            obj.put("media_id", param.getHeadImg());

            int count = cereShopCustomerServiceDAO.selectCount(Wrappers.<ShopCustomerService>lambdaQuery().eq(ShopCustomerService::getShopId, ContextUtil.getShopId()));
            //5000个客服，支持500个商家，每个商家最多10个客服
            if (count >= 10) {
                throw new CoBusinessException(CoReturnFormat.CUSTOMER_SERVICE_LIMIT);
            }

            String addResult = wxCpServiceImpl.post(WxCpConstants.API_KF_ADD, obj.toJSONString());
            log.info("addResult: {}", addResult);
            if (addResult != null) {
                JSONObject resultObj = JSON.parseObject(addResult);
                Integer errCode = resultObj.getInteger("errcode");
                if (errCode != null && errCode == 0) {
                    Long shopId = ContextUtil.getShopId();
                    String openKfId = resultObj.getString("open_kfid");
                    String now = TimeUtils.yyMMddHHmmss();
                    ShopCustomerService sc = new ShopCustomerService();
                    sc.setShopId(shopId);
                    sc.setOpenKfid(openKfId);
                    sc.setCreateTime(now);
                    sc.setUpdateTime(now);
                    cereShopCustomerServiceDAO.insert(sc);
                }
            }
        } catch (Exception e) {
            log.error("save: " + e.getMessage(), e);
        }
        return new Result<>(result);
    }

    @PostMapping("update")
    @ApiOperation("更新客服")
    public Result<Integer> update(@RequestBody CereCustomerService param, HttpServletRequest request) {
        try {
            JSONObject obj = new JSONObject();
            obj.put("open_kfid", param.getOpenKfId());
            obj.put("name", param.getName());
            obj.put("media_id", param.getHeadImg());

            String addResult = wxCpServiceImpl.post(WxCpConstants.API_KF_UPDATE, obj.toJSONString());
            log.info("updateResult: {}", addResult);
        } catch (Exception e) {
            log.error("save: " + e.getMessage(), e);
        }

        int result = 0;
        return new Result<>(result);
    }

    @PostMapping("delete")
    @ApiOperation("删除客服")
    public Result<Integer> delete(@RequestBody CereCustomerService param, HttpServletRequest request) {
        try {
            JSONObject obj = new JSONObject();
            obj.put("open_kfid", param.getOpenKfId());

            String postResult = wxCpServiceImpl.post(WxCpConstants.API_KF_DEL, obj.toJSONString());
            log.info("postResult {}", postResult);

            if (postResult != null && JSON.parseObject(postResult).getInteger("errcode") == 0) {
                cereShopCustomerServiceDAO.delete(Wrappers.<ShopCustomerService>lambdaQuery().eq(ShopCustomerService::getOpenKfid, param.getKfId()));
            }
        } catch (Exception e) {
            log.error("delete: " + e.getMessage(), e);
        }
        return new Result<>(1);
    }

    @PostMapping("getAllReceptionist")
    @ApiOperation("查询某个客服下的接待员列表")
    public Result<List<CereCustomerServiceReceptionist>> getAllReceptionist(@RequestBody CereCustomerServiceReceptionist param,
                                                                            HttpServletRequest request) {
        try {
            String result = wxCpServiceImpl.get(WxCpConstants.API_KF_SERVICER_LIST, "open_kfid=" + param.getOpenKfId());
            if (result != null) {
                JSONObject obj = JSONObject.parseObject(result);
                JSONArray array = obj.getJSONArray("servicer_list");
                if (array != null) {
                    List<CereCustomerServiceReceptionist> list = new ArrayList<>();
                    List<String> userIdList = new ArrayList<>();
                    Map<String, CereCustomerServiceReceptionist> map = new HashMap<>();
                    for (int i=0;i<array.size();i++) {
                        CereCustomerServiceReceptionist item = new CereCustomerServiceReceptionist();
                        JSONObject servicer = array.getJSONObject(i);
                        String userId = servicer.getString("userid");
                        userIdList.add(userId);
                        Integer status = servicer.getInteger("status");
                        item.setOpenKfId(param.getOpenKfId());
                        item.setUserIdList(Collections.singletonList(userId));
                        item.setState(status);
                        list.add(item);
                        map.put(userId, item);
                    }

                    if (userIdList.size() > 0) {
                        for (String userId:userIdList) {
                            WxCpUser user = wxCpServiceImpl.getUserService().getById(userId);
                            if (user != null) {
                                map.get(userId).setName(user.getName());
                            }
                        }
                    }

                    return new Result<>(list);
                }
            }
        } catch (Exception e) {
            log.error("save: " + e.getMessage(), e);
        }
        return new Result<>();
    }

    @PostMapping("saveReceptionist")
    @ApiOperation("新增接待员")
    public Result<Integer> saveReceptionist(@RequestBody CereCustomerServiceReceptionist param,
                                            HttpServletRequest request) {
        try {
            JSONObject obj = new JSONObject();
            obj.put("open_kfid", param.getOpenKfId());
            obj.put("userid_list", param.getUserIdList());
            String postResult = wxCpServiceImpl.post(WxCpConstants.API_KF_SERVICER_ADD, obj.toJSONString());
            log.info("postResult: {}", postResult);
        } catch (Exception e) {
            log.error("saveReceptionist: " + e.getMessage(), e);
        }
        return new Result<>(1);
    }

    @PostMapping("deleteReceptionist")
    @ApiOperation("删除接待员")
    public Result<Integer> deleteReceptionist(@RequestBody CereCustomerServiceReceptionist param,
                                              HttpServletRequest request) {
        try {
            JSONObject obj = new JSONObject();
            obj.put("open_kfid", param.getOpenKfId());
            obj.put("userid_list", param.getUserIdList());
            String postResult = wxCpServiceImpl.post(WxCpConstants.API_KF_SERVICER_DEL, obj.toJSONString());
            log.info("postResult: {}", postResult);
        } catch (Exception e) {
            log.error("saveReceptionist: " + e.getMessage(), e);
        }
        return new Result<>(1);
    }

    @PostMapping("getDepartmentList")
    @ApiOperation("查询部门")
    public Result<List<WxCpDepart>> getDepartmentList(HttpServletRequest request) {
        try {
            List<WxCpDepart> departmentList = wxCpServiceImpl.getDepartmentService().list(null);
            return new Result<>(departmentList);
        } catch (Exception e) {
            log.error("getDepartmentList: " + e.getMessage(), e);
        }
        return new Result<>();
    }

    @PostMapping("getExternalUserList")
    @ApiOperation("根据部门查询用户")
    public Result<List<WxCpUser>> getUserListByDepartment(@RequestBody WxCpDepart dept) {
        try {
            List<WxCpUser> userList = wxCpUserService.listByDepartment(dept.getId(), true, null);
            return new Result<>(userList);
        } catch (Exception e) {
            log.error("getUserListByDepartment: " + e.getMessage(), e);
        }
        return new Result<>();
    }

    /**
     * 返回accessToken
     * @param request
     * @return
     * @throws WxErrorException
     */
    private String getAccessToken(HttpServletRequest request) throws WxErrorException {
        return wxCpServiceImpl.getAccessToken();
    }

}
