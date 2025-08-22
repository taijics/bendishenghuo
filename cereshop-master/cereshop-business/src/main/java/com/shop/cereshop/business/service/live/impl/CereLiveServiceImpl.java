package com.shop.cereshop.business.service.live.impl;

import cn.hutool.core.date.DateUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.shop.cereshop.business.dao.live.CereLiveDAO;
import com.shop.cereshop.business.dao.live.CereLiveExamineDAO;
import com.shop.cereshop.business.dao.live.CereLiveProductDAO;
import com.shop.cereshop.business.dao.live.CereLiveProductRelDAO;
import com.shop.cereshop.business.dao.shop.CerePlatformShopDAO;
import com.shop.cereshop.business.page.live.LiveProductPage;
import com.shop.cereshop.business.param.live.*;
import com.shop.cereshop.business.service.live.CereLiveService;
import com.shop.cereshop.business.service.log.CerePlatformLogService;
import com.shop.cereshop.business.utils.EncodeUtil;
import com.shop.cereshop.commons.constant.CoReturnFormat;
import com.shop.cereshop.commons.constant.IntegerEnum;
import com.shop.cereshop.commons.domain.business.CerePlatformBusiness;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.domain.live.CereLive;
import com.shop.cereshop.commons.domain.live.CereLiveExamine;
import com.shop.cereshop.commons.domain.live.CereLiveProduct;
import com.shop.cereshop.commons.domain.live.CereLiveProductRel;
import com.shop.cereshop.commons.domain.shop.CerePlatformShop;
import com.shop.cereshop.commons.exception.CoBusinessException;
import com.shop.cereshop.commons.utils.EmptyUtils;
import com.shop.cereshop.commons.utils.StringUtils;
import com.shop.cereshop.commons.utils.TimeUtils;
import com.shop.cereshop.commons.utils.third.WxLiveUtil;
import org.apache.commons.collections4.CollectionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Collection;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class CereLiveServiceImpl implements CereLiveService {

    @Autowired
    private CereLiveDAO cereLiveDAO;

    @Autowired
    private CereLiveProductRelDAO cereLiveProductRelDAO;

    @Autowired
    private CerePlatformLogService cerePlatformLogService;

    @Autowired
    private CereLiveExamineDAO cereLiveExamineDAO;

    @Autowired
    private WxLiveUtil wxLiveUtil;

    @Autowired
    private CerePlatformShopDAO cerePlatformShopDAO;

    @Autowired
    private CereLiveProductDAO cereLiveProductDAO;

    @Autowired
    private EncodeUtil encodeUtil;

    private static final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    @Override
    public Page getAll(LiveGetAllParam param) throws CoBusinessException {
        PageHelper.startPage(param.getPage(),param.getPageSize());
        List<CereLive> list=cereLiveDAO.getAll(param);
        for (CereLive live:list) {
            live.setAnchorNickname(encodeUtil.encodeInfo(live.getAnchorNickname()));
            live.setAnchorWechat(encodeUtil.encodeInfo(live.getAnchorWechat()));
        }
        PageInfo<CereLive> pageInfo=new PageInfo<>(list);
        Page<CereLive> page=new Page(pageInfo.getList(),pageInfo.getTotal());
        return page;
    }

    @Override
    public int save(CereLive live, CerePlatformBusiness user) throws CoBusinessException {
        String time = TimeUtils.yyMMddHHmmss();
        live.setState(IntegerEnum.COMMON_WAIT_AUDIT.getCode());
        live.setCreateTime(time);
        live.setUpdateTime(time);
        validate(live);
        //查询商家配置，是否需要直播间审核
        CerePlatformShop shop = cerePlatformShopDAO.selectById(user.getShopId());
        if (IntegerEnum.NO.getCode().equals(shop.getAuditLiveProduct())) {
            live.setState(IntegerEnum.COMMON_AUDIT_SUCCESS.getCode());
            Integer roomId = wxLiveUtil.createRoom(live);
            if (roomId != null) {
                live.setRoomId(roomId);
            } else {
                throw new CoBusinessException(CoReturnFormat.LIVE_ADD_GOODS_FAIL);
            }
        }
        //新增日志
        cerePlatformLogService.addLog(user,"新建直播间","商户端操作","新建直播间",null,time);
        return cereLiveDAO.insert(live);
    }

    @Override
    public int update(CereLive live, CerePlatformBusiness user) throws CoBusinessException {
        String time = TimeUtils.yyMMddHHmmss();
        live.setState(IntegerEnum.COMMON_WAIT_AUDIT.getCode());
        live.setUpdateTime(time);
        validate(live);
        if (StringUtils.isBlank(live.getAnchorWechat())) {
            CereLive oldLive = cereLiveDAO.selectById(live.getId());
            live.setAnchorWechat(oldLive.getAnchorWechat());
        }
        //调用接口编辑直播间
        wxLiveUtil.updateRoom(live);
        //新增日志
        cerePlatformLogService.addLog(user,"修改直播间","商户端操作","修改直播间",null,time);
        return cereLiveDAO.updateById(live);
    }

    @Override
    public int delete(Long id, CerePlatformBusiness user) {
        String time = TimeUtils.yyMMddHHmmss();
        CereLive live = cereLiveDAO.getByIdAndShopId(id, user.getShopId());
        if (live.getRoomId() != null) {
            wxLiveUtil.deleteRoom(live.getRoomId());
        }
        //新增日志
        cerePlatformLogService.addLog(user,"删除直播间","商户端操作","删除直播间",null,time);
        cereLiveDAO.deleteByIdAndShopId(id, user.getShopId());
        cereLiveProductRelDAO.deleteByLiveIdAndShopId(id, user.getShopId());
        return cereLiveDAO.deleteByIdAndShopId(id, user.getShopId());
    }

    @Override
    public CereLive getById(LiveParam param) {
        return cereLiveDAO.getByIdAndShopId(param.getId(), param.getShopId());
    }

    @Override
    public int importProduct(LiveProductRelParam param, CerePlatformBusiness user) throws CoBusinessException {
        String time = TimeUtils.yyMMddHHmmss();
        List<Integer> goodsIdList = cereLiveProductRelDAO.selectLiveGoodsIdList(param.getLiveId());
        cereLiveProductRelDAO.deleteByLiveIdAndShopId(param.getLiveId(), user.getShopId());
        int result = 0;
        if (!EmptyUtils.isEmpty(param.getLiveProductIdList())) {
            LambdaQueryWrapper<CereLiveProduct> wrapper = new LambdaQueryWrapper<>();
            wrapper.in(CereLiveProduct::getId, param.getLiveProductIdList());
            List<CereLiveProduct> liveProductList = cereLiveProductDAO.selectList(wrapper);
            List<Integer> importGoodsIdList = liveProductList.stream().map(CereLiveProduct::getGoodsId).collect(Collectors.toList());
            if (importGoodsIdList.size() != param.getLiveProductIdList().size()) {
                throw new CoBusinessException(CoReturnFormat.LIVE_PRODUCT_UNPUSH);
            }
            CereLive live = null;
            //交集
            Collection<Integer> interList = CollectionUtils.intersection(goodsIdList, importGoodsIdList);
            goodsIdList.removeAll(interList);
            //剩下的代表需要从直播间商品列表中删除的
            if (CollectionUtils.isNotEmpty(goodsIdList)) {
                live = cereLiveDAO.selectById(param.getLiveId());
                wxLiveUtil.deleteGoodsInRoom(live.getRoomId(), goodsIdList);
            }

            importGoodsIdList.removeAll(interList);
            if (CollectionUtils.isNotEmpty(importGoodsIdList)) {
                if (live == null) {
                    live = cereLiveDAO.selectById(param.getLiveId());
                }
                wxLiveUtil.addGoodsToRoom(live.getRoomId(), importGoodsIdList);
            }
            for (Long liveProductId:param.getLiveProductIdList()) {
                CereLiveProductRel liveProductRel = new CereLiveProductRel();
                liveProductRel.setLiveId(param.getLiveId());
                liveProductRel.setLiveProductId(liveProductId);
                liveProductRel.setCreateTime(time);
                liveProductRel.setUpdateTime(time);
                result += cereLiveProductRelDAO.save(liveProductRel);
            }
        }
        //新增日志
        cerePlatformLogService.addLog(user,"导入直播间商品","商户端操作","导入直播间商品",param.getLiveId(),time);
        return result;
    }

    @Override
    public int reExamine(LiveParam param) throws CoBusinessException {
        //校验今天是否重新审核超过次数
        LambdaQueryWrapper<CereLiveExamine> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(CereLiveExamine::getLiveId, param.getId());
        wrapper.eq(CereLiveExamine::getReExamineDate, LocalDate.now());
        int count = cereLiveExamineDAO.selectCount(wrapper);
        if (count >= 3) {
            throw new CoBusinessException(CoReturnFormat.LIVE_RE_EXAMINE_LIMIT);
        }
        CereLive live = new CereLive();
        live.setId(param.getId());
        live.setState(IntegerEnum.COMMON_WAIT_AUDIT.getCode());
        cereLiveDAO.updateById(live);

        String time = TimeUtils.yyMMddHHmmss();
        CereLiveExamine examine = new CereLiveExamine();
        examine.setLiveId(param.getId());
        examine.setReExamineDate(LocalDate.now());
        examine.setCreateTime(time);
        examine.setUpdateTime(time);
        return cereLiveExamineDAO.insert(examine);
    }

    @Override
    public boolean verifyAnchor(AnchorWechatParam param) throws CoBusinessException {
        return wxLiveUtil.getAnchorRole(param.getAnchorWechat());
    }

    @Override
    public Page<LiveProductPage> getLiveProductRelPageByLiveId(LiveProductPageParam param) {
        PageHelper.startPage(param.getPage(),param.getPageSize());
        List<LiveProductPage> list=cereLiveDAO.getLiveProductRelPageByLiveId(param);
        PageInfo<LiveProductPage> pageInfo=new PageInfo<>(list);
        Page<LiveProductPage> page=new Page(pageInfo.getList(),pageInfo.getTotal());
        return page;
    }

    private void validate(CereLive live) throws CoBusinessException {
        if (!StringUtils.checkLength(live.getTitle(), 3, 17)) {
            throw new CoBusinessException(CoReturnFormat.LIVE_TITLE_VALID);
        }
        if (!StringUtils.checkLength(live.getAnchorNickname(), 2, 15)) {
            throw new CoBusinessException(CoReturnFormat.LIVE_ANCHOR_NICKNAME_VALID);
        }
        LocalDateTime sixMonthLater = LocalDateTime.now().plusMonths(6);
        if (live.getStartTime().compareTo(sixMonthLater.format(formatter)) > 0) {
            throw new CoBusinessException(CoReturnFormat.LIVE_START_TIME_MAX);
        }
        long startTimeMills = TimeUtils.parseDate(live.getStartTime()).getTime();
        long endTimeMills = TimeUtils.parseDate(live.getEndTime()).getTime();
        //不能超过24小时
        if (endTimeMills - startTimeMills < 30 * 60 * 1000
                || endTimeMills - startTimeMills > 24 * 60 * 60 * 1000) {
            throw new CoBusinessException(CoReturnFormat.LIVE_TIME_INTERVAL);
        }
        if (live.getRoomId() != null) {
            if (live.getStartTime().compareTo(TimeUtils.yyMMddHHmmss()) <= 0) {
                throw new CoBusinessException(CoReturnFormat.LIVE_UPDATE_FORBID);
            }
        } else {
            Date thirtyMinutesAfter = new Date(System.currentTimeMillis() + 30 * 60 * 1000);
            if (live.getStartTime().compareTo(DateUtil.format(thirtyMinutesAfter, "yyyy-MM-dd HH:mm:ss")) <= 0) {
                throw new CoBusinessException(CoReturnFormat.LIVE_START_TIME_VALID);
            }
        }
    }

}
