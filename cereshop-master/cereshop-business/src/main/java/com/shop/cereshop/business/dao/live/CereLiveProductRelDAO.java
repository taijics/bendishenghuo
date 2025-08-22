package com.shop.cereshop.business.dao.live;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.shop.cereshop.commons.domain.live.CereLiveProductRel;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface CereLiveProductRelDAO extends BaseMapper<CereLiveProductRel> {

    int save(CereLiveProductRel rel);

    int deleteByLiveIdAndShopId(@Param("liveId") Long liveId, @Param("shopId") Long shopId);

    List<Integer> selectLiveGoodsIdList(Long liveId);
}
