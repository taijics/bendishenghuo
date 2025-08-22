/**
 * @FileDescription:
 * @Author: kahu
 * @Date: 2023/5/15
 * @LastEditors: kahu
 * @LastEditTime: 2023/5/15
 */
// @ts-ignore
import store from '@/store'

export function useLoading(){
    function showLoading(info){
        store.commit('SET_SHOW_LOADING', { flag: true, info });
    }
    function hideLoading(){
        store.commit('SET_SHOW_LOADING', { flag: false });
    }
    return{
        showLoading,
        hideLoading
    }
}
