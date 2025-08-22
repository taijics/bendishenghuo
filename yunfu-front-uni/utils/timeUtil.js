/**
 * @FileDescription:
 * @Author: kahu
 * @Date: 2022/11/7
 * @LastEditors: kahu
 * @LastEditTime: 2022/11/7
 */
/**
 * 时间格式化
 * @param endTimeStamp
 * @constructor
 */
export const TimeFormatting = (timeDifference)=>{
    // 天数
    let day = Math.floor(timeDifference / 3600 / 24);
    // 小时
    let hr = Math.floor(timeDifference / 3600 % 24);
    // 分钟
    let min = Math.floor(timeDifference / 60 % 60);
    // 秒
    let sec = Math.floor(timeDifference % 60);
    return {
        day : timeFormat(day),
        hour: timeFormat(hr),
        min : timeFormat(min),
        sec : timeFormat(sec)
    }
}
//时分秒换算
function timeFormat(param) { //小于10的格式化函数
    return param < 10 ? '0' + param : param;
}
