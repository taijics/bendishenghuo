package com.shop.cereshop.business.dao.product;

import com.shop.cereshop.commons.domain.product.CereProductStatsByDay;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface CereProductStatsByDayDAO {

    List<CereProductStatsByDay> selectStatsByTime(@Param("shopId") Long shopId,
                                                  @Param("startTime") String startTime,
                                                  @Param("endTime") String endTime);

}
