// @ts-ignore
import store from '@/store'

export function btnUseLoading(){
    function btnShowLoading(){
        store.commit('SET_SHOW_BTNLOADING', { flag: true });
    }
    function btnHideLoading(){
        console.log('lsdjfldsjlfks')
        store.commit('SET_SHOW_BTNLOADING', { flag: false });
    }
    return{
        btnShowLoading,
        btnHideLoading
    }
}
