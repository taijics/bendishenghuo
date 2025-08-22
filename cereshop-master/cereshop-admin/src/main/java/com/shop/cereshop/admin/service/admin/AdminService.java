package com.shop.cereshop.admin.service.admin;

import com.shop.cereshop.admin.param.admin.IndexCharts;
import com.shop.cereshop.admin.param.admin.IndexStats;

public interface AdminService {

    IndexStats indexStats();

    IndexCharts indexCharts();
}
