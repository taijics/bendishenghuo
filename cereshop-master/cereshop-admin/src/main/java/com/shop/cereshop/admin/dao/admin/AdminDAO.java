package com.shop.cereshop.admin.dao.admin;

import com.shop.cereshop.admin.param.admin.StatsAmountByDay;
import com.shop.cereshop.admin.param.admin.StatsByDay;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface AdminDAO {

    List<StatsByDay> selectUserCount(@Param("startTime") String startTime, @Param("endTime") String endTime);

    List<StatsByDay> selectVisitCount(@Param("startTime") String startTime, @Param("endTime") String endTime);

    List<StatsByDay> selectVisitUserCount(@Param("startTime") String startTime, @Param("endTime") String endTime);

    List<StatsByDay> selectShopCount(@Param("startTime") String startTime, @Param("endTime") String endTime);

    List<StatsAmountByDay> selectOrderAmountList(@Param("startTime") String startTime, @Param("endTime") String endTime);

    List<StatsByDay> selectOrderCountList(@Param("startTime") String startTime, @Param("endTime") String endTime);

    Integer selectOrderCountSum(@Param("startTime") String startTime, @Param("endTime") String endTime);

    List<StatsByDay> selectPayUserCountList(@Param("startTime") String startTime, @Param("endTime") String endTime);

    Integer selectPayUserCountSum(@Param("startTime") String startTime, @Param("endTime") String endTime);
}
