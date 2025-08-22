<template>
  <el-dialog
    v-model="visible"
    :close-on-click-modal="false"
    :title="tipState ? '新增' : '编辑'"
    width="600px"
  >
    <el-form label-width="80px">
      <el-form-item label="标签名称">
        <el-input
          v-model="form.name"
          maxlength="32"
          placeholder="最多输入32个字符"
        />
      </el-form-item>
      <el-form-item label="标签类型">
        <el-radio-group v-model="form.type">
          <el-radio :label="1">手动标签</el-radio>
          <el-radio :label="2">自动标签</el-radio>
        </el-radio-group>
      </el-form-item>
      <div v-if="form.type === 2" class="auto_label">
        <el-form-item label="满足条件">
          <el-radio-group v-model="form.meetCondition">
            <el-radio :label="1">满足任意选中的条件即可</el-radio>
            <el-radio :label="2">必须满足所有选被中的条件</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="交易条件">
          <el-checkbox-group v-model="checkBox">
            <el-row>
              <el-checkbox :label="1" name="config">最后消费时间</el-checkbox>
              <el-row>
                <el-radio-group v-model="form.config.lastConsumTime.type">
                  <el-row class="indent">
                    <el-radio :label="1">最近</el-radio>
                    <el-select
                      v-model="form.config.lastConsumTime.value"
                      style="width: 70px"
                      :disabled="
                        form.config.lastConsumTime.type === 2 ||
                        !checkBox.includes(1)
                      "
                    >
                      <el-option
                        v-for="(item, index) in dayList"
                        :key="index"
                        :label="item.label"
                        :value="item.label"
                      />
                    </el-select>
                    <span style="font-size: 14px; margin-left: 10px">天</span>
                  </el-row>
                  <el-row class="indent">
                    <el-radio :label="2">自定义</el-radio>
                    <el-date-picker
                      v-model="date"
                      :disabled="
                        form.config.lastConsumTime.type === 1 ||
                        !checkBox.includes(1)
                      "
                      type="daterange"
                      range-separator="至"
                      start-placeholder="开始时间"
                      end-placeholder="结束时间"
                      value-format="YYYY-MM-DD"
                      @change="handleChange"
                    />
                  </el-row>
                </el-radio-group>
              </el-row>
            </el-row>
            <el-row>
              <el-checkbox :label="2" name="config">累计消费次数</el-checkbox>
              <el-row class="indent">
                <el-col :span="5" class="unit">
                  <el-input
                    v-model="totalConsumTimes.start"
                    maxlength="9"
                    :disabled="!checkBox.includes(2)"
                    oninput="value=value.replace(/[^\d]/g,'')"
                  >
                    <template #suffix>
                      <span>次</span>
                    </template>
                  </el-input>
                </el-col>
                <el-col :span="2" style="font-size: 14px; text-align: center"
                  >ㅡ</el-col
                >
                <el-col :span="5" class="unit">
                  <el-input
                    v-model="totalConsumTimes.end"
                    maxlength="9"
                    :disabled="!checkBox.includes(2)"
                    oninput="value=value.replace(/[^\d]/g,'')"
                  >
                    <template #suffix>
                      <span>次</span>
                    </template>
                  </el-input>
                </el-col>
              </el-row>
            </el-row>
            <el-row>
              <el-checkbox :label="3" name="config">累计消费金额</el-checkbox>
              <el-row class="indent">
                <el-col :span="5" class="unit">
                  <el-input
                    v-model="totalConsumAmount.start"
                    maxlength="9"
                    :disabled="!checkBox.includes(3)"
                    oninput="value=value.replace(/^\D*(\d*(?:\.\d{0,2})?).*$/g, '$1')"
                  >
                    <template #suffix>
                      <span>元</span>
                    </template>
                  </el-input>
                </el-col>
                <el-col :span="2" style="font-size: 14px; text-align: center"
                  >ㅡ</el-col
                >
                <el-col :span="5" class="unit">
                  <el-input
                    v-model="totalConsumAmount.end"
                    maxlength="9"
                    :disabled="!checkBox.includes(3)"
                    oninput="value=value.replace(/^\D*(\d*(?:\.\d{0,2})?).*$/g, '$1')"
                  >
                    <template #suffix>
                      <span>元</span>
                    </template>
                  </el-input>
                </el-col>
              </el-row>
            </el-row>
          </el-checkbox-group>
        </el-form-item>
      </div>
    </el-form>
    <div class="addtips">
      <div class="add_page">
        <div class="add_content"></div>
      </div>
    </div>
    <template #footer>
      <div class="dialog-footer">
        <div class="btn_list">
          <el-button @click="back">取消</el-button>
          <el-button type="primary" @click="save">保存</el-button>
        </div>
      </div>
    </template>
  </el-dialog>
</template>

<script setup>
import { ref } from "vue";
import { tipsAdd, tipsGetById, tipsUpdate } from "@/api/customerMage";

function AddForm() {
  this.labelType = ""; // 标签类型 1-手动标签 2-自动标签
  this.meetConditions = ""; // 满足条件 1-满足任意一个被选中条件即可  2-必须满足所有被选中条件
  this.lastConsumptionTime = ""; // 是否选中最后消费时间 1-是 0-否
  this.consumptionFrequency = ""; // 是否选中累计消费次数  1-是 0-否
  this.consumptionMoney = ""; // 是否选中累计交易金额 1-是 0-否
  this.consumptionDay = ""; // 最近几天（天）
  this.consumptionStartTime = ""; // 最后消费开始时间
  this.consumptionEndTime = ""; // 最后消费结束时间
  this.frequencyStart = ""; // 起始次数
  this.frequencyEnd = ""; // 截止次数
  this.moneyStart = ""; // 起始金额
  this.moneyEnd = ""; // 截止金额
}
function FormInfo() {
  this.name = ""; // 标签名称
  this.meetCondition = 1; // 满足条件
  this.type = 1;
  this.config = {
    totalConsumTimes: "",
    // 最近
    lastConsumTime: {
      type: 1,
      value: 3,
    },
    totalConsumAmount: "",
  };
}

let visible = ref(false);
let form = ref(new FormInfo());
let addForm = ref(new AddForm());
let checkBox = ref([]); // 交易条件
let totalConsumTimes = ref({
  start: "",
  end: "",
});
let totalConsumAmount = ref({
  start: "",
  end: "",
});
let tipState = ref(false);
let date = ref([]); // 自定义时间
const dayList = ref([
  { label: 3 },
  { label: 7 },
  { label: 15 },
  { label: 30 },
  { label: 45 },
  { label: 60 },
]);
let buyerLabelId = ref("");
const emits = defineEmits(["reset"]);

const show = (params) => {
  tipState.value = !params;
  visible.value = true;
  if (tipState.value) {
    addForm.value = new AddForm();
    form.value = new FormInfo();
  } else {
    buyerLabelId.value = params.buyerLabelId;
    getDetails(params.buyerLabelId);
  }
};
defineExpose({ show });

const handleChange = (value) => {
  console.log(value);
  // this.form.config.lastConsumTime.value = `${(value && value[0]) || ''}${value && value[0] ? '至' : ''}${(value && value[1]) || ''}`
};
// 返回
const back = () => {
  visible.value = false;
};
// 编辑查询
const getDetails = (buyerLabelId) => {
  tipsGetById({ buyerLabelId }).then((res) => {
    form.value = {
      name: res.data.labelName, // 标签名称
      meetCondition: res.data.meetConditions, // 满足条件
      type: res.data.labelType,
      config: {
        totalConsumTimes: "",
        // 最近
        lastConsumTime: {
          type: 1,
          value: res.data.consumptionDay,
        },
        totalConsumAmount: "",
      },
    };
    totalConsumTimes.value = {
      start: res.data.frequencyStart,
      end: res.data.frequencyEnd,
    };
    totalConsumAmount.value = {
      start: res.data.moneyStart,
      end: res.data.moneyEnd,
    };
    checkBox.value = res.data.consumptions;
  });
};
// 添加/编辑
function save () {
  if (form.value.type === 1) {
    form.value.config.lastConsumTime.value = "";
    form.value.meetConditions = "";
  }
  let params = {
    labelName: form.value.name, // 标签名称
    labelType: form.value.type, // 标签类型 1-手动标签 2-自动标签
    meetConditions: form.value.meetCondition,
    conditions: checkBox.value,
    consumptionDay: form.value.config.lastConsumTime.value, // 最近几天（天）
    consumptionStartTime: date.value[0] || "", // 最后消费开始时间
    consumptionEndTime: date.value[1] || "", // 最后消费结束时间
    frequencyStart: totalConsumTimes.value.start, // 起始次数
    frequencyEnd: totalConsumTimes.value.end, // 截止次数
    moneyStart: totalConsumAmount.value.start, // 起始金额
    moneyEnd: totalConsumAmount.value.end, // 截止金额
  };
  const fn = tipState.value ? tipsAdd : tipsUpdate
  if (!tipState.value) {
    params.buyerLabelId = buyerLabelId.value;
  }
  fn(params).then(res => {
    if (res.code === "") {
      ElMessage.success("操作成功");
      form.value = new FormInfo();
      visible.value = false;
      emits("reset");
    }
  }).catch(err => {
    console.log(err)
  })
}
</script>

<style lang="scss" scoped>
.auto_label {
  padding: 12px 0;
  background-color: #f7f7f7;
  border-radius: 4px;
  overflow: hidden;
  .indent {
    padding-left: 20px;
    margin-bottom: 12px;
    box-sizing: border-box;
    align-items: center;
    .unit {
      position: relative;
      span {
        position: absolute;
        right: 0;
        // font-size: 16px;
        color: #333;
        // border-left: 1px solid #dcdfe6;
        padding: 0 8px;
      }
    }
  }
}
</style>
