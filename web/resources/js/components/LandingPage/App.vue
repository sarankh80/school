<template>
<section class="our-free-service">
    <div class="container">
        <div class="free-serv">
            <div class="row row-cols-1 row-cols-md-2 row-cols-lg-2  align-items-center">
                <div class="col">
                    <div class="serv-left-sec">
                        <h3 class="mb-3">{{appsetting.title}}</h3>
                        <p  class="mb-5">{{appsetting.description}}</p>                
                        <div class="d-flex dwn-box">                       
                            <button class="dwn-link"><a :href="appsetting.play_store_url"  target="_blank"><img :src="baseUrl+'/images/frontend/googleplay.png'"></a></button>                       
                            <button class="dwn-link"><a :href="appsetting.app_store_url" target="_blank"><img :src="baseUrl+'/images/frontend/apple.png'"></a></button>
                        </div>
                    </div>
                </div>
                <div class="col">
                    <img class="mb-right" :src="baseUrl+'/images/frontend/'+ appsetting.app_image">
                    <img class="mb-right-device" :src="baseUrl+'/images/frontend/'+ appsetting.app_image_full">
                </div>
            </div>
        </div>
    </div>
</section>
</template>
<script>
export default {
  name: "AppDownload",
  data() {
    return {
        baseUrl:window.baseUrl,
        appsetting:{}
    };
  },
  mounted() {
    axios.get(this.baseUrl + "/appdownload.json")
    .then((response) => {
       this.appsetting = response.data
    });
  }
};
</script>