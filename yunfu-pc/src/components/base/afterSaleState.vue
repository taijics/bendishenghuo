<template>
    <div class="process">
        <div class="box">
            <icon-svg :class="{colorGlod : state === ''}"
                style="font-size: 90px;"
                icon-class="detail-submit"
            />
            <p>申请售后</p>
        </div>
        <span class="defaultSpot"
            :class="{glodSpot : state!==1 && state!==''}"
            v-if="state===''"
        ></span>
        <div class="box" v-if="state===1 || state===''">
            <icon-svg style="font-size: 90px; color: #999;" icon-class="detail-paySuccess" />
            <p>订单处理</p>
        </div>
        <span class="defaultSpot" :class="{glodSpot : state!==1 && state!==''}">
        </span>
        <div class="box">
            <icon-svg
                style="font-size: 90px; color: #999;"
                icon-class="order-detail-express"
            />
            <p>退货中</p>
        </div>
        <span class="defaultSpot" :class="{glodSpot : state!==1 && state!==''}">
        </span>
        <div class="box">
            <icon-svg
                style="font-size: 90px; color: #999;"
                icon-class="order-detail-finish"
            />
            <p>完成</p>
        </div>
    </div>
</template>

<script>
export default {
    props: ['state'],
    data () {
        return {
        }
    }
}
</script>
<style lang="scss" scoped>
.process{
    width: 100%;
    display: flex;
    text-align: center;
    align-items: center;
    margin-top: 100px;
    .box{
        flex: 1;
        img{
            width: 35px;
            height: 35px;
            margin-bottom: 20px;
        }
        p{
            font-size: 14px;
        }
    }
    .spot{
        width: 130px;
        position: relative;
        margin-top: 5px;
        img{
            width: 130px;
        }
        p{
            position: absolute;
            top: -20px;
            left: 50%;
            transform: translate(-50%, 0);
        }
    }
    .defaultSpot{
        flex: 0.5;
        height: 0;
        border-bottom: 8px dotted #CCCCCC;
        span{
            position: relative;
            top: -20px;
        }
    }
    .glodSpot{
        border-color: $mainGlod;
    }
    .colorGlod{
        color: $mainGlod;
    }
}
</style>
