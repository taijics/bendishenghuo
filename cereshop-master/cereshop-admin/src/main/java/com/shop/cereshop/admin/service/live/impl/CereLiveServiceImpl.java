package com.shop.cereshop.admin.service.live.impl;

import cn.hutool.core.date.DateUtil;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.shop.cereshop.admin.dao.live.CereLiveDAO;
import com.shop.cereshop.admin.page.live.LiveProductPage;
import com.shop.cereshop.admin.param.live.LiveGetAllParam;
import com.shop.cereshop.admin.param.live.LiveParam;
import com.shop.cereshop.admin.param.live.LiveProductPageParam;
import com.shop.cereshop.admin.service.live.CereLiveService;
import com.shop.cereshop.admin.service.log.CerePlatformLogService;
import com.shop.cereshop.admin.utils.EncodeUtil;
import com.shop.cereshop.commons.constant.CoReturnFormat;
import com.shop.cereshop.commons.constant.IntegerEnum;
import com.shop.cereshop.commons.domain.common.Page;
import com.shop.cereshop.commons.domain.live.CereLive;
import com.shop.cereshop.commons.domain.user.CerePlatformUser;
import com.shop.cereshop.commons.exception.CoBusinessException;
import com.shop.cereshop.commons.utils.TimeUtils;
import com.shop.cereshop.commons.utils.third.WxLiveUtil;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
public class CereLiveServiceImpl implements CereLiveService {

    @Autowired
    private CereLiveDAO cereLiveDAO;

    @Autowired
    private CerePlatformLogService cerePlatformLogService;

    @Autowired
    private WxLiveUtil wxLiveUtil;

    @Autowired
    private EncodeUtil encodeUtil;

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
    public int audit(LiveParam param, CerePlatformUser user) throws CoBusinessException {
        if (StringUtils.isNotBlank(param.getRemark()) && param.getRemark().length() > 32) {
            throw new CoBusinessException(CoReturnFormat.AUDIT_REMARK_LENGTH_INVALID);
        }
        String time = TimeUtils.yyMMddHHmmss();
        CereLive live = new CereLive();
        BeanUtils.copyProperties(param, live);
        live.setUpdateTime(time);
        if (IntegerEnum.COMMON_AUDIT_SUCCESS.getCode().equals(param.getState())) {
            CereLive dbLive = cereLiveDAO.getById(param.getId());
            if (dbLive.getRoomId() != null) {
                if (live.getStartTime().compareTo(TimeUtils.yyMMddHHmmss()) <= 0) {
                    throw new CoBusinessException(CoReturnFormat.LIVE_UPDATE_FORBID);
                }
                wxLiveUtil.updateRoom(dbLive);
            } else {
                //创建直播间之前，先校验开始时间是否合法
                Date thirtyMinutesAfter = new Date(System.currentTimeMillis() + 30 * 60 * 1000);
                if (live.getStartTime().compareTo(DateUtil.format(thirtyMinutesAfter, "yyyy-MM-dd HH:mm:ss")) <= 0) {
                    throw new CoBusinessException(CoReturnFormat.LIVE_START_TIME_VALID);
                }
                Integer roomId = wxLiveUtil.createRoom(dbLive);
                if (roomId != null) {
                    live.setRoomId(roomId);
                } else {
                    throw new CoBusinessException(CoReturnFormat.LIVE_CREATE_ROOM_FAIL);
                }
            }
        }
        //新增日志
        cerePlatformLogService.addLog(user,"审核直播间","平台端操作","审核直播间",null,time);
        return cereLiveDAO.audit(live);
    }

    @Override
    public CereLive getById(LiveParam param) {
        return cereLiveDAO.getById(param.getId());
    }

    @Override
    public Page<LiveProductPage> getLiveProductRelPageByLiveId(LiveProductPageParam param) {
        PageHelper.startPage(param.getPage(),param.getPageSize());
        List<LiveProductPage> list=cereLiveDAO.getLiveProductRelPageByLiveId(param);
        PageInfo<LiveProductPage> pageInfo=new PageInfo<>(list);
        Page<LiveProductPage> page=new Page(pageInfo.getList(),pageInfo.getTotal());
        return page;
    }

    @Override
    public List<CereLive> selectLiveList() {
        return cereLiveDAO.selectLiveList(TimeUtils.yyMMddHHmmss());
    }

}
