/*
 * Copyright (C) 2017-2021
 * All rights reserved, Designed By 深圳中科鑫智科技有限公司
 * Copyright authorization contact 18814114118
 */
package com.shop.cereshop.app.controller.shop;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.shop.cereshop.app.page.banner.ShopBanner;
import com.shop.cereshop.app.page.settlement.SettlementShop;
import com.shop.cereshop.app.page.shop.Shop;
import com.shop.cereshop.app.page.shop.ShopClassify;
import com.shop.cereshop.app.page.shop.ShopIndex;
import com.shop.cereshop.app.page.shop.ShopIndexVo;
import com.shop.cereshop.app.param.shop.ShopIndexParam;
import com.shop.cereshop.app.param.shop.ShopParam;
import com.shop.cereshop.app.param.shop.ShopPosterParam;
import com.shop.cereshop.app.service.business.CereBusinessBuyerUserService;
import com.shop.cereshop.app.service.buyer.CereBuyerUserService;
import com.shop.cereshop.app.service.shop.CerePlatformShopservice;
import com.shop.cereshop.commons.constant.CoReturnFormat;
import com.shop.cereshop.commons.domain.business.CereBusinessBuyerUser;
import com.shop.cereshop.commons.domain.buyer.CereBuyerUser;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.exception.CoBusinessException;
import com.shop.cereshop.commons.result.Result;
import com.shop.cereshop.commons.utils.EmptyUtils;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;

/**
 * 店铺模块
 */
@RestController
@RequestMapping("shop")
/**
 * 注解方式生成日志对象，指定topic生成对象类名
 */
@Slf4j(topic = "ShopController")
@Api(value = "店铺模块", tags = "店铺模块")
public class ShopController {

	@Autowired
	private CerePlatformShopservice cerePlatformShopservice;

	@Autowired
	private CereBuyerUserService cereBuyerUserService;

	@Autowired
	private CereBusinessBuyerUserService cereBusinessBuyerUserService;

	/**
	 * 店铺商品查询
	 * @return
	 */
	@GetMapping("getShopProducts")
	@ApiOperation(value = "商品搜索查询")
	public Result<Shop> getShopProducts(ShopParam param, HttpServletRequest request) throws CoBusinessException {
		String token = request.getHeader("Authorization");
		CereBuyerUser user = null;
		if (!EmptyUtils.isEmpty(token)) {
			// 根据token查询用户信息
			user = cereBuyerUserService.findByToken(token);
		}
		Shop shop = cerePlatformShopservice.getShopProducts(param, user);
		return new Result(shop, CoReturnFormat.SUCCESS);
	}

	/**
	 * 店铺搜索
	 * @return
	 */
	@GetMapping("getShops")
	@ApiOperation(value = "店铺搜索")
	public Result<Page<SettlementShop>> getShops(ShopParam param, HttpServletRequest request)
			throws CoBusinessException {
		String token = request.getHeader("Authorization");
		CereBuyerUser user = null;
		if (!EmptyUtils.isEmpty(token)) {
			// 根据token查询用户信息
			user = cereBuyerUserService.findByToken(token);
		}
		Page page = cerePlatformShopservice.getShops(param, user);
		return new Result(page, CoReturnFormat.SUCCESS);
	}

	/**
	 * 首页商家列表
	 * @param param
	 * @param request
	 * @return
	 * @throws CoBusinessException
	 */
	/**
	 * 首页商家列表（Mock 版：生成27条默认数据，支持分页与排序）
	 * @param param
	 * @param request
	 * @return
	 * @throws CoBusinessException
	 */
	@GetMapping("getShopsBySortType")
	@ApiOperation(value = "首页商家列表")
	public Result<Page<ShopIndexVo>> getShops(ShopIndexParam param, HttpServletRequest request)
			throws CoBusinessException {

		// 读取分页参数：优先用对象中的 page/pageSize；兼容 query: page/size
		Integer pageNo = param != null ? param.getPage() : null;
		Integer pageSize = param != null ? param.getPageSize() : null;
		if (pageNo == null || pageNo <= 0) {
			String pageStr = request.getParameter("page");
			pageNo = EmptyUtils.isEmpty(pageStr) ? 1 : Integer.parseInt(pageStr);
		}
		if (pageSize == null || pageSize <= 0) {
			String sizeStr = request.getParameter("size");
			pageSize = EmptyUtils.isEmpty(sizeStr) ? 10 : Integer.parseInt(sizeStr);
		}

		// 读取排序：type（1距离 2推荐 3销量），兼容 sort=distance|recommend|sales
		Integer type = param != null ? param.getType() : null;
		if (type == null) {
			String sort = request.getParameter("sort");
			if ("distance".equalsIgnoreCase(sort)) {
				type = 1;
			} else if ("sales".equalsIgnoreCase(sort)) {
				type = 3;
			} else {
				type = 2; // recommend 或默认
			}
		}

		// 生成27条默认数据
		List<ShopIndexVo> all = new ArrayList<>(27);
		String[] cats = new String[] { "美食", "超市", "生鲜", "家政", "服饰", "数码", "母婴", "美妆", "健身" };
		for (int i = 1; i <= 27; i++) {
			ShopIndexVo vo = new ShopIndexVo();
			vo.setShopId((long) i);
			vo.setShopName("示例商家 " + i);
			// 随机一个可用logo（前端也会兜底）
			vo.setShopLogo("https://picsum.photos/seed/shop" + i + "/200/200");
			// 销量基于序号构造，便于可视化排序
			vo.setNumber(50 + (i * 7) % 300);
			// 营业状态：1营业 / 0打烊
			vo.setBusinessStatus(i % 3 == 0 ? 0 : 1);
			// 分利比例：0.5% ~ 8.5%
			vo.setIntegrationRatio(0.5 + ((i * 13) % 800) / 100.0);
			// 类别
			vo.setTypeName(cats[(i - 1) % cats.length]);
			// 地址与经纬度
			vo.setAddress("深圳市南山区科苑大道" + i + "号");
			vo.setGis("{\"lat\":22." + (500 + i) + ",\"lng\":113." + (900 + i) + "}");
			// 距离（米）：构造不同区间
			vo.setDistance(Double.valueOf(120 + ((i * 137) % 4800))); // 120m ～ 4919m
			all.add(vo);
		}

		// 排序
		if (type != null && type == 1) {
			// 距离升序
			all.sort(Comparator.comparing(o -> o.getDistance() == null ? Double.MAX_VALUE : o.getDistance()));
		} else if (type != null && type == 3) {
			// 销量倒序
			all.sort((a, b) -> {
				Integer an = a.getNumber() == null ? 0 : a.getNumber();
				Integer bn = b.getNumber() == null ? 0 : b.getNumber();
				return Integer.compare(bn, an);
			});
		}
		// type==2 推荐：保持原始顺序

		// 分页
		int total = all.size();
		int fromIndex = Math.max(0, (pageNo - 1) * pageSize);
		int toIndex = Math.min(total, fromIndex + pageSize);
		List<ShopIndexVo> pageList = fromIndex >= total ? new ArrayList<>() : all.subList(fromIndex, toIndex);

		Page<ShopIndexVo> page = new Page<>(pageList, total);
		return new Result(page, CoReturnFormat.SUCCESS);
	}

	/**
	 * 查询店铺分类
	 * @return
	 */
	@GetMapping("getShopClassify")
	@ApiOperation(value = "查询店铺分类")
	public Result<List<ShopClassify>> getShopClassify(ShopParam param) throws CoBusinessException {
		List<ShopClassify> list = cerePlatformShopservice.getShopClassify(param);
		return new Result(list, CoReturnFormat.SUCCESS);
	}

	/**
	 * 查询店铺banner
	 * @return
	 */
	@GetMapping("getShopBanner")
	@ApiOperation(value = "查询店铺banner")
	public Result<List<ShopBanner>> getShopBanner(ShopParam param) throws CoBusinessException {
		List<ShopBanner> list = cerePlatformShopservice.getShopBanner(param.getShopId());
		return new Result(list, CoReturnFormat.SUCCESS);
	}

	/**
	 * 店铺首页查询
	 * @return
	 */
	@GetMapping("getIndex")
	@ApiOperation(value = "店铺首页查询")
	public Result<ShopIndex> getIndex(ShopParam param, HttpServletRequest request)
			throws CoBusinessException, Exception {
		String token = request.getHeader("Authorization");
		CereBuyerUser user = null;
		if (!EmptyUtils.isEmpty(token)) {
			// 根据token查询用户信息
			user = cereBuyerUserService.findByToken(token);
		}
		ShopIndex index = cerePlatformShopservice.getIndex(param, user);
		return new Result(index, CoReturnFormat.SUCCESS);
	}

	/**
	 * 获取分享图片
	 * @param param
	 * @return
	 */
	@GetMapping("getSharePic")
	@ApiOperation(value = "获取分享图片")
	public Result<String> getSharePic(ShopPosterParam param, HttpServletRequest request) throws CoBusinessException {
		String token = request.getHeader("Authorization");
		CereBuyerUser user = null;
		if (!EmptyUtils.isEmpty(token)) {
			// 根据token查询用户信息
			user = cereBuyerUserService.findByToken(token);
		}
		String sharePicUrl = cerePlatformShopservice.getSharePic(param, user);
		Result<String> result = new Result();
		result.setCode(CoReturnFormat.SUCCESS);
		result.setData(sharePicUrl);
		return result;
	}

	@PostMapping("addBusinessBuyerUser")
	@ApiOperation(value = "添加客户访问商家的记录")
	public Result<Boolean> addBusinessBuyerUser(@RequestBody CereBusinessBuyerUser cereBusinessBuyerUser,
			HttpServletRequest request) {
		String token = request.getHeader("Authorization");
		CereBuyerUser user = null;
		if (!EmptyUtils.isEmpty(token)) {
			// 根据token查询用户信息
			user = cereBuyerUserService.findByToken(token);
			if (user != null && user.getBuyerUserId() != null) {
				cereBusinessBuyerUser.setBuyerUserId(user.getBuyerUserId());
				cereBusinessBuyerUserService.addBusinessBuyerUser(cereBusinessBuyerUser);
			}
		}
		return new Result(true, CoReturnFormat.SUCCESS);
	}
}
