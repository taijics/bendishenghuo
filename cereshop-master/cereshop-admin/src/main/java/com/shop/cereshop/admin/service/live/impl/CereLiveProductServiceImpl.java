package com.shop.cereshop.admin.service.live.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.shop.cereshop.admin.dao.live.CereLiveProductDAO;
import com.shop.cereshop.admin.dao.product.CereProductSkuDAO;
import com.shop.cereshop.admin.page.product.Sku;
import com.shop.cereshop.admin.param.live.LiveProductGetAllParam;
import com.shop.cereshop.admin.param.live.LiveProductParam;
import com.shop.cereshop.admin.service.live.CereLiveProductService;
import com.shop.cereshop.admin.service.log.CerePlatformLogService;
import com.shop.cereshop.commons.constant.CoReturnFormat;
import com.shop.cereshop.commons.constant.IntegerEnum;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.domain.live.CereLiveProduct;
import com.shop.cereshop.commons.domain.user.CerePlatformUser;
import com.shop.cereshop.commons.exception.CoBusinessException;
import com.shop.cereshop.commons.upload.strategy.FileStrategy;
import com.shop.cereshop.commons.utils.TimeUtils;
import com.shop.cereshop.commons.utils.third.WxLiveUtil;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;

import java.io.InputStream;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class CereLiveProductServiceImpl implements CereLiveProductService {

    @Autowired
    private CereLiveProductDAO cereLiveProductDAO;

    @Autowired
    private CerePlatformLogService cerePlatformLogService;

    @Autowired
    private WxLiveUtil wxLiveUtil;

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
    public int audit(LiveProductParam param, CerePlatformUser user) throws CoBusinessException {
        if (StringUtils.isNotBlank(param.getRemark()) && param.getRemark().length() > 32) {
            throw new CoBusinessException(CoReturnFormat.AUDIT_REMARK_LENGTH_INVALID);
        }
        String time = TimeUtils.yyMMddHHmmss();
        CereLiveProduct liveProduct = new CereLiveProduct();
        BeanUtils.copyProperties(param, liveProduct);
        liveProduct.setUpdateTime(time);
        if (IntegerEnum.COMMON_AUDIT_SUCCESS.getCode().equals(param.getState())) {
            CereLiveProduct dbLiveProduct = cereLiveProductDAO.getById(param.getId());
            if (StringUtils.isBlank(dbLiveProduct.getProductImageMediaId())) {
                InputStream inputStream = fileStrategy.getInputStream(dbLiveProduct.getProductImage());
                String ext = FilenameUtils.getExtension(dbLiveProduct.getProductImage());
                String mediaId = wxLiveUtil.uploadMedia(inputStream, ext);
                if (mediaId != null) {
                    dbLiveProduct.setProductImageMediaId(mediaId);
                    liveProduct.setProductImageMediaId(mediaId);
                }
            }
            List<Sku> skuList = cereProductSkuDAO.findByProductId(dbLiveProduct.getProductId());
            if (CollectionUtils.isEmpty(skuList)) {
                throw new CoBusinessException(CoReturnFormat.LIVE_ADD_GOODS_FAIL);
            }
            Integer goodsId = wxLiveUtil.addGoods(dbLiveProduct, skuList.get(0).getSkuId());
            if (goodsId != null) {
                liveProduct.setGoodsId(goodsId);
            } else {
                throw new CoBusinessException(CoReturnFormat.LIVE_ADD_GOODS_FAIL);
            }
        }
        //新增日志
        cerePlatformLogService.addLog(user,"审核直播间商品","商户端操作","审核直播间商品",null,time);
        return cereLiveProductDAO.audit(liveProduct);
    }

    @Override
    public CereLiveProduct getById(LiveProductParam param) {
        return cereLiveProductDAO.getById(param.getId());
    }
}
