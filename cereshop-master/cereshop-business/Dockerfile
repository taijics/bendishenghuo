FROM registry.cn-shenzhen.aliyuncs.com/sumply-shop/openjdk8-font
ADD target/cereshop-business /home/cereshop-business
ADD cert/ /home/ceres/cert
WORKDIR /home/cereshop-business
ENTRYPOINT ["java","-jar","cereshop-business.jar"]
