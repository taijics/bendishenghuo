// 中间部分
export function hidden (str, frontLen, endLen) {
  let endLenData = 0
	if(!str.length || !str){
		return ''
	}
  if (str.length !== 2) {
    endLenData = endLen
  }
  const len = str.length - frontLen - endLenData;
  let xing = '';
  for (let i = 0; i < len; i++) {
    xing += '*';
  }
  return (
    str.substring(0, frontLen) + xing + str.substring(str.length - endLenData)
  );
}
