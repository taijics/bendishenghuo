package com.shop.cereshop.business.service.live.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.shop.cereshop.business.dao.live.CereLiveProductDAO;
import com.shop.cereshop.business.dao.live.CereLiveProductExamineDAO;
import com.shop.cereshop.business.dao.product.CereProductSkuDAO;
import com.shop.cereshop.business.dao.shop.CerePlatformShopDAO;
import com.shop.cereshop.business.page.product.Sku;
import com.shop.cereshop.business.param.live.LiveProductGetAllParam;
import com.shop.cereshop.business.param.live.LiveProductParam;
import com.shop.cereshop.business.service.live.CereLiveProductService;
import com.shop.cereshop.business.service.log.CerePlatformLogService;
import com.shop.cereshop.commons.constant.CoReturnFormat;
import com.shop.cereshop.commons.constant.IntegerEnum;
import com.shop.cereshop.commons.domain.business.CerePlatformBusiness;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.domain.live.CereLiveProduct;
import com.shop.cereshop.commons.domain.live.CereLiveProductExamine;
import com.shop.cereshop.commons.domain.shop.CerePlatformShop;
import com.shop.cereshop.commons.exception.CoBusinessException;
import com.shop.cereshop.commons.upload.strategy.FileStrategy;
import com.shop.cereshop.commons.utils.TimeUtils;
import com.shop.cereshop.commons.utils.ValidationUtil;
import com.shop.cereshop.commons.utils.third.WxLiveUtil;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;

import java.io.InputStream;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class CereLiveProductServiceImpl implements CereLiveProductService {

    private static final BigDecimal MIN_PRICE = new BigDecimal("0.01");
    private static final BigDecimal MAX_PRICE = new BigDecimal("10000000");

    @Autowired
    private CereLiveProductDAO cereLiveProductDAO;

    @Autowired
    private CerePlatformLogService cerePlatformLogService;

    @Autowired
    private CereLiveProductExamineDAO cereLiveProductExamineDAO;

    @Autowired
    private WxLiveUtil wxLiveUtil;

    @Autowired
    private CerePlatformShopDAO cerePlatformShopDAO;

    @Autowired
    private FileStrategy fileStrategy;

    @Autowired
    private CereProductSkuDAO cereProductSkuDAO;

    @Override
    public Page getAll(LiveProductGetAllParam param) throws CoBusinessException {
        PageHelper.startPage(param.getPage(),param.getPageSize());
        List<CereLiveProduct> list=cereLiveProductDAO.getAll(param);
        list.forEach(obj ->{
            obj.setWxAuditStatus(-1);
        });
        List<Integer> goodsIdList = list.stream().map(CereLiveProduct::getGoodsId).collect(Collectors.toList());
        Map<Integer, Integer> goodsAuditStatusMap = wxLiveUtil.getGoodsState(goodsIdList);
        if (goodsAuditStatusMap != null) {
            for (CereLiveProduct product:list) {
                product.setWxAuditStatus(goodsAuditStatusMap.get(product.getGoodsId()));
            }
        }
        PageInfo<CereLiveProduct> pageInfo=new PageInfo<>(list);
        Page<CereLiveProduct> page=new Page(pageInfo.getList(),pageInfo.getTotal());
        return page;
    }

    @Override
    public int save(LiveProductParam param, CerePlatformBusiness user) throws CoBusinessException {
        String time = TimeUtils.yyMMddHHmmss();
        CereLiveProduct liveProduct = new CereLiveProduct();
        BeanUtils.copyProperties(param, liveProduct);
        liveProduct.setState(IntegerEnum.COMMON_WAIT_AUDIT.getCode());
        liveProduct.setCreateTime(time);
        liveProduct.setUpdateTime(time);
        //校验参数
        validate(liveProduct);
        //查询商家配置，是否需要直播间商品审核
        CerePlatformShop shop = cerePlatformShopDAO.selectById(user.getShopId());
        if (IntegerEnum.NO.getCode().equals(shop.getAuditLiveProduct())) {
            liveProduct.setState(IntegerEnum.COMMON_AUDIT_SUCCESS.getCode());
            if (StringUtils.isBlank(liveProduct.getProductImageMediaId())) {
                InputStream inputStream = fileStrategy.getInputStream(liveProduct.getProductImage());
                String ext = FilenameUtils.getExtension(liveProduct.getProductImage());
                String mediaId = wxLiveUtil.uploadMedia(inputStream, ext);
                if (mediaId != null) {
                    liveProduct.setProductImageMediaId(mediaId);
                    liveProduct.setProductImageMediaId(mediaId);
                }
            }
            List<Sku> skuList = cereProductSkuDAO.findByProductId(liveProduct.getProductId());
            if (CollectionUtils.isEmpty(skuList)) {
                throw new CoBusinessException(CoReturnFormat.LIVE_ADD_GOODS_FAIL);
            }
            Integer goodsId = wxLiveUtil.addGoods(liveProduct, skuList.get(0).getSkuId());
            if (goodsId != null) {
                liveProduct.setGoodsId(goodsId);
            } else {
                throw new CoBusinessException(CoReturnFormat.LIVE_ADD_GOODS_FAIL);
            }
        }
        //新增日志
        cerePlatformLogService.addLog(user,"新增直播间商品","商户端操作","新增直播间商品",null,time);
        return cereLiveProductDAO.insert(liveProduct);
    }

    @Override
    public int update(LiveProductParam param, CerePlatformBusiness user) throws CoBusinessException {
        String time = TimeUtils.yyMMddHHmmss();
        CereLiveProduct liveProduct = new CereLiveProduct();
        BeanUtils.copyProperties(param, liveProduct);
        //liveProduct.setState(IntegerEnum.COMMON_WAIT_AUDIT.getCode());
        liveProduct.setUpdateTime(time);
        //校验参数
        validate(liveProduct);
        wxLiveUtil.updateGoods(liveProduct);
        //新增日志
        cerePlatformLogService.addLog(user,"修改直播间商品","商户端操作","修改直播间商品",null,time);
        return cereLiveProductDAO.updateByPrimaryKey(liveProduct);
    }

    @Override
    public int delete(Long id, CerePlatformBusiness user) {
        String time = TimeUtils.yyMMddHHmmss();

        //删除微信直播间的商品
        CereLiveProduct liveProduct = cereLiveProductDAO.getByIdAndShopId(id, user.getShopId());
        wxLiveUtil.deleteGoods(liveProduct.getGoodsId());

        cereLiveProductDAO.deleteByIdAndShopId(id, user.getShopId());

        //新增日志
        cerePlatformLogService.addLog(user,"删除直播间商品","商户端操作","删除直播间商品",null,time);
        return cereLiveProductDAO.deleteByIdAndShopId(id, user.getShopId());
    }

    @Override
    public CereLiveProduct getById(LiveProductParam param) {
        return cereLiveProductDAO.getByIdAndShopId(param.getId(), param.getShopId());
    }

    @Override
    public int reExamine(LiveProductParam param) throws CoBusinessException {
        //校验今天是否重新审核超过次数
        LambdaQueryWrapper<CereLiveProductExamine> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(CereLiveProductExamine::getLiveProductId, param.getId());
        wrapper.eq(CereLiveProductExamine::getReExamineDate, LocalDate.now());
        int count = cereLiveProductExamineDAO.selectCount(wrapper);
        if (count >= 3) {
            throw new CoBusinessException(CoReturnFormat.LIVE_PRODUCT_RE_EXAMINE_LIMIT);
        }
        CereLiveProduct liveProduct = new CereLiveProduct();
        liveProduct.setId(param.getId());
        liveProduct.setState(IntegerEnum.COMMON_WAIT_AUDIT.getCode());
        cereLiveProductDAO.updateById(liveProduct);

        String time = TimeUtils.yyMMddHHmmss();
        CereLiveProductExamine examine = new CereLiveProductExamine();
        examine.setLiveProductId(param.getId());
        examine.setReExamineDate(LocalDate.now());
        examine.setCreateTime(time);
        examine.setUpdateTime(time);
        //wxLiveUtil.reAuditGoods(liveProduct.getGoodsId());
        return cereLiveProductExamineDAO.insert(examine);
    }

    /**
     * 校验必填参数
     * @param liveProduct
     * @throws CoBusinessException
     */
    private void validate(CereLiveProduct liveProduct) throws CoBusinessException {
        int count = cereLiveProductDAO.selectCountByProductIdAndId(liveProduct.getProductId(), liveProduct.getId());
        if (count != 0) {
            throw new CoBusinessException(CoReturnFormat.LIVE_PRODUCT_EXISTS);
        }
        if (liveProduct.getPriceType() != null) {
            if (liveProduct.getPriceType() == 1 && liveProduct.getFixedPrice() == null) {
                throw new CoBusinessException(CoReturnFormat.PARAM_MISSING);
            }
            if (liveProduct.getPriceType() == 2 && (liveProduct.getMinPrice() == null || liveProduct.getMaxPrice() == null)) {
                throw new CoBusinessException(CoReturnFormat.PARAM_MISSING);
            }
            if (liveProduct.getPriceType() == 3 && liveProduct.getMarketPrice() == null) {
                throw new CoBusinessException(CoReturnFormat.PARAM_MISSING);
            }
            if (liveProduct.getPriceType() == 1 && !ValidationUtil.checkPrice(liveProduct.getFixedPrice(), MIN_PRICE, MAX_PRICE)) {
                throw new CoBusinessException(CoReturnFormat.LIVE_PRODUCT_PRICE_VALID);
            }
            if (liveProduct.getPriceType() == 2
                    && (!ValidationUtil.checkPrice(liveProduct.getMinPrice(), MIN_PRICE, MAX_PRICE)
                        || !ValidationUtil.checkPrice(liveProduct.getMaxPrice(), MIN_PRICE, MAX_PRICE))) {
                throw new CoBusinessException(CoReturnFormat.LIVE_PRODUCT_PRICE_VALID);
            }
            if (liveProduct.getPriceType() == 3 && !ValidationUtil.checkPrice(liveProduct.getMarketPrice(), MIN_PRICE, MAX_PRICE)) {
                throw new CoBusinessException(CoReturnFormat.LIVE_PRODUCT_PRICE_VALID);
            }
        }
        if (!com.shop.cereshop.commons.utils.StringUtils.checkLength(liveProduct.getProductName(), 3, 14)) {
            throw new CoBusinessException(CoReturnFormat.LIVE_PRODUCT_NAME_VALID);
        }
    }

}
