/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
/*
 *  Copyright 2019-2020 Zheng Jie
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */
package com.shop.cereshop.commons.utils;

import cn.hutool.core.collection.CollectionUtil;
import com.github.pagehelper.PageInfo;
import org.springframework.data.domain.Page;
import java.util.*;

/**
 * 分页工具
 * @author Zheng Jie
 * @date 2018-12-10
 */
public class PageUtil extends cn.hutool.core.util.PageUtil {

    /**
     * List 分页
     */
    public static List toPage(int page, int size , List list) {
        int fromIndex = page * size;
        int toIndex = page * size + size;
        if(fromIndex > list.size()){
            return new ArrayList();
        } else if(toIndex >= list.size()) {
            return list.subList(fromIndex,list.size());
        } else {
            return list.subList(fromIndex,toIndex);
        }
    }

    public static PageInfo getPageData(Integer page, Integer size, List list) {
        if(CollectionUtil.isNotEmpty(list)){
            Integer listSize = list.size();
            list = list.subList((page-1)*size > listSize ? listSize: (page-1)*size, page*size > listSize ? listSize: page*size);
            PageInfo pageBean = new PageInfo(list);
            pageBean.setPageNum(page);
            pageBean.setSize(size);
            pageBean.setTotal(listSize);
            return pageBean;
        }else{
            PageInfo pageBean = new PageInfo(list);
            pageBean.setPageNum(page);
            pageBean.setSize(size);
            return pageBean;
        }

    }

    /**
     * Page 数据处理，预防redis反序列化报错
     */
    public static Map<String,Object> toPage(Page page) {
        Map<String,Object> map = new LinkedHashMap<>(2);
        map.put("content",page.getContent());
        map.put("totalElements",page.getTotalElements());
        return map;
    }

    /**
     * 自定义分页
     */
    public static Map<String,Object> toPage(Object object, Object totalElements) {
        Map<String,Object> map = new LinkedHashMap<>(2);
        map.put("content",object);
        map.put("totalElements",totalElements);
        return map;
    }

}
