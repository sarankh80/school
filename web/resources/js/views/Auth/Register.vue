<template>
    <div>
        <b-modal id="my-modal1" ref="registermodal" title="Register">
            <form
                action="javascript:void(0)"
                @submit="register"
                class="row"
                method="post"
            >
                <div class="form-group col-sm-6 col-12">
                    <label for="name" class="font-weight-bold">{{__('auth.first_name')}}</label>
                    <input
                        type="text"
                        name="first_name"
                        v-model="user.first_name"
                        id="first_name"
                        :placeholder="__('auth.first_name')"
                        class="form-control"
                    />
                </div>
                <div class="form-group col-sm-6 col-12">
                    <label for="last_name" class="font-weight-bold">{{__('auth.last_name')}}</label>
                    <input
                        type="text"
                        name="last_name"
                        v-model="user.last_name"
                        id="last_name"
                        :placeholder="__('auth.last_name')"
                        class="form-control"
                    />
                </div>
                <div class="form-group col-sm-6 col-12">
                    <label for="username" class="font-weight-bold">{{__('auth.username')}}</label>
                    <input
                        type="text"
                        name="username"
                        v-model="user.username"
                        id="username"
                        :placeholder="__('auth.username')"
                        class="form-control"
                    />
                </div>
                <div class="form-group col-sm-6 col-12">
                    <label for="email" class="font-weight-bold">{{__('auth.email')}}</label>
                    <input
                        type="email"
                        name="email"
                        v-model="user.email"
                        id="email"
                        :placeholder="__('auth.email')"
                        class="form-control"
                    />
                </div>
                <div class="form-group col-sm-6 col-12">
                    <label for="password" class="font-weight-bold">{{__('auth.login_password')}}</label>
                     <i v-if="showpassword" class="fa fa-eye text-primary" @click="showregpass"></i>
                     <i v-else class="fa fa-eye-slash text-primary" @click="showregpass"></i>
                    <input
                        type="password"
                        name="password"
                        v-model="user.password"
                        id="regpassword"
                        :placeholder="__('auth.login_password')"
                        class="form-control"
                    />
                </div>
                <div class="form-group col-6">
                    <label for="password_confirmation" class="font-weight-bold"
                    >{{__('auth.confirm_password')}}</label
                    >
                    <input
                        type="password"
                        name="password_confirmation"
                        v-model="user.password_confirmation"
                        id="password_confirmation"
                        :placeholder="__('auth.confirm_password')"
                        class="form-control"
                    />
                </div>
                <div class="form-group col-sm-12 col-12">
                    <label for="contact_no" class="font-weight-bold">{{__('messages.phone_number')}}</label>
                    <input
                        type="text"
                        name="contact_no"
                        v-model="user.contact_no"
                        id="contact_no"
                        :placeholder="__('messages.phone_number')"
                        class="form-control"
                    />
                </div>
                <div class="col-12 mb-2 text-center">
                    <button
                        type="submit"
                        :disabled="processing"
                        class="btn btn-primary btn-block"
                    >
                        {{ processing ? "Please wait" : "Register" }}
                    </button>
                </div>
                <div class="col-12 text-center">
                    <label
                        class="d-flex align-item-center flex-column justify-content-center"
                    >{{__('auth.already_have_account')}}
                        <div  @click="closeregistermodal">
                            <a href="#">{{__('auth.sign_in')}}</a>
                        </div></label
                    >
                </div>
            </form>
        </b-modal>
        <login-component ref="openModal" />
    </div>
</template>

<script>
import { displayError } from '../../messages';
export default {
    name: "Register",
    data() {
        return {
            user: {
                first_name: "",
                last_name: "",
                username: "",
                email: "",
                contact_no: "",
                password: "",
                password_confirmation: "",
            },
            processing: false,
            showpassword:true
        };
    },
    methods: {
        async register() {
            this.$store
                .dispatch("register", this.user)
                .then(() => {
                    this.closeregistermodal();
                })
                .catch((err) => {
                    displayError(err.response.data.message)
                });
        },
        closeregistermodal() {
            this.$refs["registermodal"].hide();
        },
         showregpass(){
            this.showpassword=!this.showpassword
            var elem= document.querySelector('#regpassword')
            const type = elem.getAttribute('type') === 'password' ? 'text' : 'password';
            elem.setAttribute('type', type);
        }
    },
};
</script>
<style scoped>
.form-group {
  position: relative;
}

.form-group > i {
  position: absolute;
  right:2rem;
  top:50px
}
</style>
