<template>
    <div class="evaluateList">
    <div class="sub-main" v-if="data.length > 0">
        <div class="content" v-for="(item,index) in data" :key="index">
            <div class="head">
                <img :src="item.shopLogo" style="width:17px; height:17px;"/>&nbsp;{{item.shopName}}
            </div>
            <div class="productBox">
                <div class="product">
                    <div class="left fs13">
                        <div class="box">
                            <div class="desc">
                                <img :src="item.productImage" alt="">
                                <div>
                                    <p class="name">{{item.productName}}</p>
                                    <p class="size font-color-999"><span v-for="(val,idx) in item.values" :key="idx">{{val}}</span></p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="right">
                        <div class="time">
                            <p>{{item.value}}</p>
                        </div>
                        <div class="operate">
                            <div>
                                <p v-if="item.comment === ''" @click="emit('eva',item)">评价</p>
                                <p v-if="item.comment !== ''" @click="emit('detail',item)">查看评价</p>
                                <p v-if="item.ifAdd==0 && item.comment !== ''" @click="emit('addEva',item)">去追评</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="nothing" v-else>
        <icon-svg style="width: 240px; height: 240px; margin-bottom: 20px;" icon-class="user-order-nodata" />
        <p class="fs20 font-color-999">你还没有评价～</p>
    </div>
    </div>
</template>

<script>
export default {
    props: {
        data: {
            type: Array,
            default: () => []
        }
    },
    methods: {
        emit (key, val) {
            this.$emit(key, val)
        }
    }
}
</script>

<style lang="scss" scoped>
.evaluateList{
    .content{
        width: 100%;
        margin-bottom: 20px;
        border: 1px solid #E5E5E5;
        border-bottom: 0;
        box-sizing: border-box;
        .head{
            width: 100%;
            height: 40px;
            padding-left: 15px;
            color: #FFF;
            background-color: #333333;
            display: flex;
            align-items: center;
        }
        .productBox{
            width: 100%;
            box-sizing: border-box;
            .product{
                width: 100%;
                display: flex;
                .left{
                    flex: 1;
                    .box{
                        padding: 20px 0 20px 20px;
                        display: flex;
                        border-bottom: 1px solid #E5E5E5;
                        .desc{
                            flex: 1;
                            display: flex;
                            img{
                                width: 86px;
                                height: 86px;
                                margin-right: 10px;
                            }
                            div{
                                display: flex;
                                flex-direction: column;
                                justify-content: space-between;
                                .name{
                                    font-size: 14px;
                                }
                                .size{
                                    font-size: 13px;
                                    span{
                                        margin-right: 10px;
                                    }
                                    span:last-child{
                                        margin-right: 0;
                                    }
                                }
                            }
                        }
                    }
                }
                .right{
                    padding: 20px 20px 20px 0;
                    flex: 2;
                    display: flex;
                    border-bottom: 1px solid #E5E5E5;
                    .time,.operate{
                        display: flex;
                        justify-content: center;
                        align-items: center;
                        div{
                            text-align: center;
                            .el-button{
                                border: 1px solid $mainGlod;
                                color: $mainGlod;
                                border-radius: 0;
                            }
                            p{
                                padding: 7px 23px;
                                color: $mainGlod;
                                border: 1px solid #F3F4F5;
                                cursor: pointer;
                            }
                        }
                    }
                    .time{
                        flex: 1;
                    }
                }
            }
        }
    }
    .nothing{
        width: 100%;
        text-align: center;
        min-height: 400px;
        p{
            margin-bottom: 20px;
        }
    }
}
</style>
