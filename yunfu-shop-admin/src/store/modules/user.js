import {
    login,
    logout
} from '@/api/user'
import {
    getToken,
    setToken,
    removeToken,
    setName,
    setAvatar,
    setShopId,
    setUserId
} from '@/utils/auth'
import {
    resetRouter
} from '@/router'

const getDefaultState = () => {
    return {
        token: getToken(),
        name: '',
        avatar: ''
    }
}

const state = getDefaultState()

const mutations = {
    RESET_STATE: (state) => {
        Object.assign(state, getDefaultState())
    },
    SET_TOKEN: (state, token) => {
        state.token = token
    },
    SET_NAME: (state, name) => {
        state.name = name
    },
    SET_AVATAR: (state, avatar) => {
        state.avatar = avatar
    }
}

const actions = {
    // user login
    login({
        commit
    }, userInfo) {
        const {
            username,
            password,
            code,
            rememberMe
        } = userInfo
        return new Promise((resolve, reject) => {
            login({
                username: username.trim(),
                password: password,
                code: code,
                rememberMe: rememberMe
            }).then(response => {
                const {
                    data
                } = response
                setName(data.name)
                console.log('avatar', data.avatar)
                setAvatar(data.avatar)
                commit('SET_TOKEN', data.token)
                setToken(data.token)
                setShopId(data.shopId)
                setUserId(data.businessUserId)
                resolve()
                location.reload()
            }).catch(error => {
                reject(error)
            })
        })
    },

    // get user info
    // getInfo({ commit, state }) {
    //   return new Promise((resolve, reject) => {
    //     getInfo(state.token).then(response => {
    //       const { data } = response

    //       if (!data) {
    //         return reject('Verification failed, please Login again.')
    //       }

    //       const { name, avatar } = data

    //       commit('SET_NAME', name)
    //       commit('SET_AVATAR', avatar)
    //       resolve(data)
    //     }).catch(error => {
    //       reject(error)
    //     })
    //   })
    // },

    // user logout
    logout({
        commit,
        state
    }) {
        return new Promise((resolve, reject) => {
            logout(state.token).then(() => {
                removeToken() // must remove  token  first
                resetRouter()
                commit('RESET_STATE')
                resolve()
            }).catch(error => {
                reject(error)
            })
        })
    },

    // remove token
    resetToken({
        commit
    }) {
        return new Promise(resolve => {
            removeToken() // must remove  token  first
            commit('RESET_STATE')
            resolve()
        })
    }
}

export default {
    namespaced: true,
    state,
    mutations,
    actions
}