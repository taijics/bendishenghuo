<template>
<div class="myEvaluate">
    <div class="search">
        <el-input v-model="this.query.search" type="text" placeholder="请输入商品名称或订单号" />
        <el-button class="searchBtn" @click="getEvaluateList">
            <i class="el-icon-search" />
        </el-button>
    </div>
    <el-tabs v-model="activeName" @tab-click="handleClick">
        <el-tab-pane label="待评价" name="待评价">
            <EvaluateTable
                :data="evaluateList"
                @eva="toEvaluate"
                @addEva="toAddEvaluate"
            />
        </el-tab-pane>
        <el-tab-pane label="待追评" name="待追评">
            <EvaluateTable
                :data="evaluateList"
                @detail="toEvaluateDetail"
                @addEva="toAddEvaluate"
            />
        </el-tab-pane>
        <el-tab-pane label="已评价" name="已评价">
            <EvaluateTable
                :data="evaluateList"
                @detail="toEvaluateDetail"
            />
        </el-tab-pane>
    </el-tabs>
    <el-pagination
        v-if="evaluateList.length > 0"
        :current-page="this.query.page"
        :total='total'
        :page-size="this.query.pageSize"
        @current-change="handleCurrentChange"
        background layout='prev, pager, next'
    ></el-pagination>
</div>
</template>
<script>
import EvaluateTable from './evaluateList.vue'
import {
    getEvaluateData
} from '@/api/user/evaluate.js'
export default {
    name: 'myEvaluate',
    components: {EvaluateTable},
    data () {
        return {
            evaluateList: [],
            query: {
                search: '',
                page: 1,
                pageSize: 10,
                type: 1
            },
            page: 1,
            total: 0,
            flag: true,
            loading: false,
            activeName: '待评价',
            type: 1,
            search: ''
        }
    },
    mounted () {
        this.getEvaluateList()
    },
    methods: {
        handleClick (e) {
            this.query.type = Number(e.index) + 1
            this.getEvaluateList()
        },
        // 获取评价列表
        async getEvaluateList () {
            this.loading = true
            const response = await getEvaluateData({
                search: this.query.search,
                page: this.query.page,
                pageSize: this.query.pageSize,
                type: this.query.type
            })
            if (response.data.code === '200') {
                this.evaluateList = response.data.data.page.list
                this.total = response.data.data.page.total
                if (response.data.data.page.list.length) {
                    this.flag = true
                } else {
                    this.flag = false
                }
                //   rLoading.close()
                this.loading = false
            } else {
                this.$message({
                    message: response.data.message,
                    type: 'warning'
                })
            }
        },
        // 跳转到评价
        toEvaluate (item) {
            let data = {
                skus: [{
                    orderId: item.orderId,
                    commentId: item.commentId,
                    productId: item.productId,
                    skuId: item.skuId,
                    image: item.productImage,
                    productName: item.productName,
                    price: item.productPrice,
                    values: [item.value]
                }]
            }
            this.$router.push({
                path: '/evaluate',
                query: {
                    product: JSON.stringify(data)
                }
            })
        },
        // 查看评价
        toEvaluateDetail (item) {
            this.$router.push({
                path: '/evaluateDetail',
                query: {
                    data: JSON.stringify(item)
                }
            })
        },
        // 去追评
        toAddEvaluate (item) {
            this.$router.push({
                path: '/addEvaluate',
                query: {
                    data: JSON.stringify(item)
                }
            })
        },
    // 跳转到商品详情
    // toProductDetail (id) {
    //     this.$router.push({
    //         path: '/productDetail',
    //         query: {
    //             productId: id
    //         }
    //     })
    // },
        handleCurrentChange (val) {
            this.query.page = val
            this.getEvaluateList()
        }
    }
}
</script>
<style lang="scss" scoped>
.myEvaluate{
    width: 100%;
    position: relative;
    >>>.el-tabs__nav-scroll{
        height: 50px;
        line-height: 50px;
        padding: 0 12px;
        background-color: #FAFAFA;
        .el-tabs__nav-wrap::after{
            content: '';
            background-color: transparent;
        }
    }
    .search{
        width: 280px;
        height: 40px;
        background: #FFFFFF;
        display: flex;
        position: absolute;
        top: 3px;
        right: 15px;
        z-index: 1000;
        >>>.el-input{
            .el-input__inner{
                border: none;
            }
        }
    }
    .noorder{
        width: 100%;
        text-align: center;
        padding: 100px 0;
        p{
            margin-bottom: 20px;
        }
        .el-button{
            background-color: $mainGlod;
            color: #FFFFFF;
            font-weight: normal;
            border-radius: 0;
        }
    }
    .head{
        box-sizing: border-box;
        width: 100%;
        height: 44px;
        background-color: #F1F2F7;
        display: flex;
        align-items: center;
        text-align: center;
        margin-bottom: 20px;
        div{
            display: flex;
        }
    }
    >>>.el-pagination{
        margin-top: 40px;
        text-align: right;
        .el-pager{
            li:not(.disabled):hover{
                color: $mainGlod;
            }
            li:not(.disabled).active{
                background-color: $mainGlod;
            }
            li:not(.disabled).active:hover{
                color: #F4F4F5;
            }
        }
    }
}
</style>
