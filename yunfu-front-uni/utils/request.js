import axios from 'axios';
import { showLoading, hideLoading, btnHideLoading } from './plugIn/globalLoading';

/*const apiClient = axios.create({
	headers: {
		'Content-Type': 'application/json',
	},
});

const request = async (url, data, method = 'GET') => {
	try {
		showLoading();
		const res = uni.getStorageSync('storage_key');
		const token = res.token;

		if (token) {
			apiClient.defaults.headers.common['Authorization'] = token;
		}

		const response = await apiClient.request({
			url: url,
			method: method,
			params: method === 'GET' ? data : {}, // Using data as URL parameters if method is 'GET'
			data: method !== 'GET' ? data : {} // Using data as a request body if method is NOT 'GET'
		});

		hideLoading();

		if (response.status === 200) {
			if (response.data.code === '200' || response.data.code === '') {
				return response.data;
			} else if (response.data.code === '20004' || response.data.code === '20005') {
				uni.removeStorageSync('storage_key');
				uni.navigateTo({
					url: '/pages_category_page2/userModule/login',
				});
			} else {
				uni.showToast({
					title: response.data.message,
					icon: 'none',
				});
			}
		} else {
			throw new Error(response.statusText);
		}
	} catch (error) {
		hideLoading();
		throw error;
	}
};

const request1 = async (url, data, method = 'GET') => {
	try {
		showLoading();

		const response = await apiClient.request({
			url: url,
			method: method,
			params: method === 'GET' ? data : {},
			data: method !== 'GET' ? data : {},
			headers: {
				'Content-Type': 'application/json',
				tenant: 'MDAwMA==',
			},
		});

		hideLoading();

		if (response.data.code === '200' || response.data.code === '') {
			return response.data;
		} else {
			throw new Error(response.statusText);
		}
	} catch (error) {
		hideLoading();
		throw error;
	}
};*/

const request = (url, data, method = 'GET', loading = true) => {
	return new Promise((resolve, reject) => {
		let header = {
			"Content-Type": "application/json"
		}
		const res = uni.getStorageSync('storage_key');
		const token = res.token
		if (token) {
			header['Authorization'] = token
		}
		if (loading) {
			showLoading()
		}
		uni.request({
			url: url,
			data: data,
			method: method,
			header: header,
			success: res => {
					hideLoading()
					btnHideLoading()
				if (res.statusCode == 200) {
					if (res.data.code === "200" || res.data.code === "") {
						resolve(res.data)
					} else if (res.data.code === "20004" || res.data.code === "20005") {
						uni.removeStorageSync("storage_key")
						const pages = getCurrentPages();
						const currentPage = pages[pages.length-1]
						console.log(currentPage)
						uni.setStorageSync('last_page', currentPage.route);
						currentPage.options&&uni.setStorageSync('last_page_options', currentPage.options)
						uni.navigateTo({
							url: '/pages_category_page2/userModule/login'
						})
					} else {
						uni.showToast({
							title: res.data.message,
							icon: "none"
						})
					}
				} else {
					reject(res)
				}
			},
			fail: res => {
				hideLoading()
				btnHideLoading()
				reject(res)
			},
		})
	});
}
//不带token接口请求，首页
const request1 = (url, data, method = 'GET') => {
	return new Promise((resolve, reject) => {
		let header = {
			'Content-Type': 'application/json',
			'tenant': 'MDAwMA==',
		}
		btnShowLoading()
		showLoading()
		uni.request({
			url: url,
			data: data,
			method: method,
			header: header,
			success: res => {
				hideLoading()
				btnHideLoading()
				if (res.data.code === "200" || data.code === "") {
					resolve(res.data)
				} else {
					reject(res)
				}
			},
			fail: res => {
				hideLoading()
				btnHideLoading()
				reject(res)
			}
		})
	});
}

export { request, request1 };
