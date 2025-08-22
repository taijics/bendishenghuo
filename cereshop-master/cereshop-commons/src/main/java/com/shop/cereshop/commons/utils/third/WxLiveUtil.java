package com.shop.cereshop.commons.utils.third;

import cn.binarywang.wx.miniapp.api.WxMaService;
import cn.binarywang.wx.miniapp.bean.live.WxMaCreateRoomResult;
import cn.binarywang.wx.miniapp.bean.live.WxMaLiveGoodInfo;
import cn.binarywang.wx.miniapp.bean.live.WxMaLiveResult;
import cn.binarywang.wx.miniapp.bean.live.WxMaLiveRoomInfo;
import cn.hutool.core.date.DateUtil;
import com.alibaba.fastjson.JSONObject;
import com.google.gson.JsonArray;
import com.shop.cereshop.commons.constant.CoReturnFormat;
import com.shop.cereshop.commons.constant.IntegerEnum;
import com.shop.cereshop.commons.constant.WxMaConstants;
import com.shop.cereshop.commons.domain.live.CereLive;
import com.shop.cereshop.commons.domain.live.CereLiveProduct;
import com.shop.cereshop.commons.exception.CoBusinessException;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import me.chanjar.weixin.common.api.WxConsts;
import me.chanjar.weixin.common.bean.result.WxMediaUploadResult;
import me.chanjar.weixin.common.error.WxErrorException;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang.StringUtils;

import java.io.InputStream;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

@Slf4j(topic = "WxLiveUtil")
@Data
@AllArgsConstructor
public class WxLiveUtil {

    private WxMaService wxMaService;

    public String uploadMedia(InputStream inputStream, String ext) {
        try {
            WxMediaUploadResult uploadMediaResult = wxMaService.getMediaService().uploadMedia(WxConsts.MediaFileType.IMAGE, ext, inputStream);
            if (uploadMediaResult.getMediaId() != null) {
                return uploadMediaResult.getMediaId();
            }
        } catch (Exception e) {
            log.error("uploadMedia: " + e.getMessage(), e);
        }
        return null;
    }

    /**
     * 创建直播间
     * @param live
     */
    public Integer createRoom(CereLive live) {
        try {
            WxMaLiveRoomInfo roomInfo = buildRoomInfo(live);
            WxMaCreateRoomResult result = wxMaService.getLiveService().createRoom(roomInfo);
            if (result != null && result.getRoomId() != null) {
                return result.getRoomId();
            }
        } catch (Exception e) {
            log.error("createRoom: " + e.getMessage(), e);
        }
        return null;
    }

    /**
     * 更新直播间
     * @param live
     */
    public void updateRoom(CereLive live) {
        try {
            if (live.getRoomId() != null) {
                WxMaLiveRoomInfo roomInfo = buildRoomInfo(live);
                boolean editResult = wxMaService.getLiveService().editRoom(roomInfo);
                log.info("updateRoom: {}", editResult);
            }
        } catch (Exception e) {
            log.error("updateRoom: " + e.getMessage(), e);
        }
    }

    /**
     * 删除直播间
     * @param roomId
     */
    public void deleteRoom(Integer roomId) {
        try {
            wxMaService.getLiveService().deleteRoom(roomId);
        } catch (Exception e) {
            log.error("deleteRoom: " + e.getMessage(), e);
        }
    }

    public WxMaLiveRoomInfo buildRoomInfo(CereLive live) {
        WxMaLiveRoomInfo roomInfo = new WxMaLiveRoomInfo();

        roomInfo.setId(live.getRoomId());
        roomInfo.setName(live.getTitle());
        //微信的cover对应我们的background
        roomInfo.setCoverImg(live.getCoverMediaId());
        roomInfo.setShareImg(live.getShareMediaId());
        roomInfo.setFeedsImg(live.getFeedsMediaId());

        roomInfo.setStartTime(DateUtil.parse(live.getStartTime()).getTime() / 1000);
        roomInfo.setEndTime(DateUtil.parse(live.getEndTime()).getTime() / 1000);

        roomInfo.setAnchorName(live.getAnchorNickname());
        roomInfo.setAnchorWechat(live.getAnchorWechat());

        roomInfo.setType(live.getLiveType());
        roomInfo.setScreenType(live.getScreenType());
        roomInfo.setCloseLike(live.getCloseLike());
        roomInfo.setCloseGoods(live.getCloseGoodsShelf());
        roomInfo.setCloseComment(live.getCloseComment());
        roomInfo.setCloseReplay(live.getClosePlayback());
        roomInfo.setCloseShare(live.getCloseShare());
        roomInfo.setCloseKf(live.getCloseService());
        return roomInfo;
    }

    public Integer addGoods(CereLiveProduct product, Long skuId) throws CoBusinessException {

        WxMaLiveGoodInfo goods = new WxMaLiveGoodInfo();
        goods.setCoverImgUrl(product.getProductImageMediaId());
        goods.setName(product.getProductName());
        goods.setPriceType(product.getPriceType());
        if (IntegerEnum.LIVE_PRODUCT_PRICE_TYPE_FIXED.getCode().equals(product.getPriceType())) {
            goods.setPrice(product.getFixedPrice());
        } else if (IntegerEnum.LIVE_PRODUCT_PRICE_TYPE_RANGE.getCode().equals(product.getPriceType())) {
            goods.setPrice(product.getMinPrice());
            goods.setPrice2(product.getMaxPrice());
        } else {
            goods.setPrice(product.getMarketPrice());
            goods.setPrice2(product.getOriginalPrice());
        }
        String goodsPath = String.format("pages_category_page1/goodsModule/goodsDetails?shopId=%s&productId=%s&skuId=%s",
                product.getShopId(), product.getProductId(), skuId);
        goods.setUrl(goodsPath);
        WxMaLiveResult liveResult = null;
        try {
            liveResult = wxMaService.getLiveGoodsService().addGoods(goods);
            log.info("liveResult: {}", liveResult);
            if (liveResult != null && liveResult.getGoodsId() != null) {
                return liveResult.getGoodsId();
            }
        } catch (WxErrorException e) {
            log.error("addGoods: " + e.getMessage(), e);
            int errorCode = e.getError().getErrorCode();
            switch (errorCode) {
                case 300004:
                    throw new CoBusinessException(CoReturnFormat.LIVE_PRODUCT_NAME_IRREGULAR);
                case 300005:
                    throw new CoBusinessException(CoReturnFormat.LIVE_PRODUCT_PIC_IRREGULAR);
                case 300012:
                    throw new CoBusinessException(CoReturnFormat.LIVE_PRODUCT_PIC_IRREGULAR);
                case 300018:
                    throw new CoBusinessException(CoReturnFormat.LIVE_PRODUCT_PIC_OVERSIZE);
            }
        }
        return null;
    }

    public void updateGoods(CereLiveProduct product) {
        try {
            if (product.getGoodsId() != null) {
                WxMaLiveGoodInfo goods = new WxMaLiveGoodInfo();
                goods.setGoodsId(product.getGoodsId());
                goods.setPriceType(product.getPriceType());
                if (IntegerEnum.LIVE_PRODUCT_PRICE_TYPE_FIXED.getCode().equals(product.getPriceType())) {
                    goods.setPrice(product.getFixedPrice());
                } else if (IntegerEnum.LIVE_PRODUCT_PRICE_TYPE_RANGE.getCode().equals(product.getPriceType())) {
                    goods.setPrice(product.getMinPrice());
                    goods.setPrice2(product.getMaxPrice());
                } else {
                    goods.setPrice(product.getMarketPrice());
                    goods.setPrice2(product.getOriginalPrice());
                }
                boolean updateGoodsResult = wxMaService.getLiveGoodsService().updateGoods(goods);
                log.info("updateGoodsResult: {}", updateGoodsResult);
            }
        } catch (Exception e) {
            log.error("updateGoods: " + e.getMessage(), e);
        }
    }

    /**
     * 重新提审商品
     */
    public void reAuditGoods(Integer goodsId) {
        try {
            if (goodsId != null) {
                String auditGoodsResult = wxMaService.getLiveGoodsService().auditGoods(goodsId);
                log.info("auditGoodsResult: {}", auditGoodsResult);
            }
        } catch (Exception e) {
            log.error("reAuditGoods: " + e.getMessage(), e);
        }
    }

    /**
     * 删除商品
     * @param goodsId
     */
    public void deleteGoods(Integer goodsId) {
        try {
            if (goodsId != null) {
                boolean deleteGoodsResult = wxMaService.getLiveGoodsService().deleteGoods(goodsId);
                log.info("deleteGoodsResult: {}", deleteGoodsResult);
            }
        } catch (Exception e) {
            log.error("deleteGoods: " + e.getMessage(), e);
        }
    }

    /**
     * 删除商品
     * @param goodsIdList
     */
    public Map<Integer, Integer> getGoodsState(List<Integer> goodsIdList) {
        try {
            if (CollectionUtils.isNotEmpty(goodsIdList)) {
                Map<Integer, Integer> goodsStateMap = new HashMap<>();
                WxMaLiveResult goodsStateResult = wxMaService.getLiveGoodsService().getGoodsWareHouse(goodsIdList);
                log.info("goodsStateResult: {}", goodsStateResult);
                if (goodsStateResult != null && CollectionUtils.isNotEmpty(goodsStateResult.getGoods())) {
                    for (WxMaLiveResult.Goods goods:goodsStateResult.getGoods()) {
                        goodsStateMap.put(goods.getGoodsId(), goods.getAuditStatus());
                    }
                    return goodsStateMap;
                }
            }
        } catch (Exception e) {
            log.error("deleteGoods: " + e.getMessage(), e);
        }
        return null;
    }

    /**
     * 查询直播间状态
     * @param roomIdList
     * @return
     */
    public Map<Integer, WxMaLiveResult.RoomInfo> queryLiveInfos(List<Integer> roomIdList) {
        if (CollectionUtils.isEmpty(roomIdList)) {
            return Collections.emptyMap();
        }
        Map<Integer, WxMaLiveResult.RoomInfo> map = new HashMap<>();
        roomIdList.sort(Integer::compare);
        int start = 0;
        int errorCount = 0;
        while (true) {
            try {
                WxMaLiveResult wxMaLiveResult = wxMaService.getLiveService().getLiveInfo(start, 10);
                if (wxMaLiveResult != null && CollectionUtils.isNotEmpty(wxMaLiveResult.getRoomInfos())) {
                    Map<Integer, WxMaLiveResult.RoomInfo> roomInfoMap = wxMaLiveResult.getRoomInfos().stream()
                            .collect(Collectors.toMap(WxMaLiveResult.RoomInfo::getRoomId, Function.identity()));
                    Iterator<Integer> ite = roomIdList.iterator();
                    while(ite.hasNext()) {
                        Integer roomId = ite.next();
                        WxMaLiveResult.RoomInfo roomInfo = roomInfoMap.get(roomId);
                        if (roomInfo != null) {
                            map.put(roomId, roomInfo);
                            ite.remove();
                        }
                    }
                    if (roomIdList.size() == 0) {
                        break;
                    }
                    start += 10;
                } else {
                    break;
                }
            } catch (Exception e) {
                start += 10;
                errorCount ++;
                if (errorCount >= 10) {
                    break;
                }
                log.error("queryLiveInfos: " + e.getMessage(), e);
            }
        }
        return map;
    }

    /**
     * 从直播间中移除商品
     * @param roomId
     * @param goodsIdList
     */
    public void deleteGoodsInRoom(Integer roomId, List<Integer> goodsIdList) throws CoBusinessException {
        if (roomId != null && CollectionUtils.isNotEmpty(goodsIdList)) {
            try {
                for (Integer goodsId:goodsIdList) {
                    JSONObject obj = new JSONObject();
                    obj.put("roomId", roomId);
                    obj.put("goodsId", goodsId);
                    wxMaService.post(WxMaConstants.LIVE_DELETE_IN_ROOM, obj.toJSONString());
                }
            } catch (Exception e) {
                log.error(e.getMessage(), e);
                throw new CoBusinessException(CoReturnFormat.DELETE_LIVE_PRODUCT_FAIL);
            }
        }
    }

    /**
     * 根据微信号查询主播角色，存在则返回true， 否则返回false
     * @param anchorWechat
     * @return
     * @throws CoBusinessException
     */
    public boolean getAnchorRole(String anchorWechat) throws CoBusinessException {
        if (StringUtils.isNotBlank(anchorWechat)) {
            try {
                Map<String, Object> map = new HashMap<>();
                map.put("role", -1);
                map.put("offset", 0);
                map.put("limit", 1);
                map.put("keyword", anchorWechat);
                JsonArray array = wxMaService.getLiveMemberService().listByRole(-1, 0, 1, anchorWechat);
                log.info("getRoleList {}", array);
                if (array != null && array.size() > 0) {
                    return true;
                }
            } catch (Exception e) {
                log.error(e.getMessage(), e);
                throw new CoBusinessException(CoReturnFormat.GET_ANCHOR_ROLE_FAIL);
            }
        }
        return false;
    }

    /**
     * 添加商品到微信直播间
     * @param roomId
     * @param importGoodsIdList
     */
    public void addGoodsToRoom(Integer roomId, List<Integer> importGoodsIdList) throws CoBusinessException {
        try {
            wxMaService.getLiveService().addGoodsToRoom(roomId, importGoodsIdList);
        } catch (WxErrorException e) {
            log.error("addGoodsToRoom fail:" + e.getMessage(), e);
            throw new CoBusinessException(CoReturnFormat.LIVE_IMPORT_PRODUCT_FAIL);
        }
    }

    /**
     * 查询直播间状态
     * @param roomIdList
     * @return

    public Map<Integer, Integer> querySubscribeStatus(String openId, List<Integer> roomIdList) {
        if (StringUtils.isBlank(openId) || CollectionUtils.isEmpty(roomIdList)) {
            return Collections.emptyMap();
        }
        Map<Integer, Integer> map = new HashMap<>();
        roomIdList.sort(Integer::compare);
        int errorCount = 0;
        Long pageBreak = 0L;
        boolean queryDone = false;
        while (true) {
            try {
                JSONObject obj = new JSONObject();
                obj.put("limit", 100);
                if (pageBreak != 0L) {
                    obj.put("page_break", pageBreak);
                }
                String followers = wxMaService.post(WxMpHostConfig.API_DEFAULT_HOST_URL + "/wxa/business/get_wxa_followers", obj.toJSONString());
                log.info("followers: {}", followers);
                if (StringUtils.isNotBlank(followers)) {
                    JSONObject resultObj = JSONObject.parseObject(followers);
                    pageBreak = resultObj.getLong("page_break");
                    JSONArray array = resultObj.getJSONArray("followers");
                    if (CollectionUtils.isEmpty(array)) {
                        break;
                    }
                    for (int i=0;i<array.size();i++) {
                        JSONObject followObj = array.getJSONObject(i);
                        Integer roomId = followObj.getInteger("room_id");
                        String folOpenId = followObj.getString("openid");
                        if (folOpenId != null && folOpenId.equals(openId) && roomIdList.contains(roomId)) {
                            map.put(roomId, 1);
                        }
                        if (map.size() == roomIdList.size()) {
                            queryDone = true;
                            break;
                        }
                    }
                    if (queryDone) {
                        break;
                    }
                } else {
                    break;
                }
            } catch (Exception e) {
                errorCount ++;
                if (errorCount >= 10) {
                    break;
                }
                log.error("querySubscribeStatus fail: " + e.getMessage(), e);
            }
        }
        return map;
    }*/
}
