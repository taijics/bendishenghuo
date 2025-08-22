/**
 * 创建一个滚动动画
 * @param scrollStart 动画开始滚动位置
 * @param scrollEnd 动画结束滚动位置
 * @param valueStart 动画值开始值
 * @param valueEnd 动画值结束值
 */
export function createAnimation(scrollStart, scrollEnd, valueStart, valueEnd) {
  return function (nowScroll) {
    if (nowScroll <= scrollStart) {
      return valueStart
    }
    if (nowScroll >= scrollEnd) {
      return valueEnd
    }
    // (nowScroll - scrollStart) / (scrollEnd - scrollStart) 当前滚动在咕哝的那个起始值中的比例
    // 用value的总值 * 比例 = value的值
    // 由于valueStart可能不是0 ， 所以需要加上valueStart
    return ((valueEnd - valueStart) * (nowScroll - scrollStart) / (scrollEnd - scrollStart)) + valueStart
  }
}
