(window.webpackJsonp=window.webpackJsonp||[]).push([["chunk-2658"],{Ddwv:function(e,t,n){var i,o,r;o=[e,n("YDNs"),n("wOJ8"),n("TiCD")],void 0===(r="function"==typeof(i=function(e,t,n,i){"use strict";var o=s(t),r=s(n),a=s(i);function s(e){return e&&e.__esModule?e:{default:e}}var l="function"==typeof Symbol&&"symbol"==typeof Symbol.iterator?function(e){return typeof e}:function(e){return e&&"function"==typeof Symbol&&e.constructor===Symbol&&e!==Symbol.prototype?"symbol":typeof e},c=function(){function e(e,t){for(var n=0;n<t.length;n++){var i=t[n];i.enumerable=i.enumerable||!1,i.configurable=!0,"value"in i&&(i.writable=!0),Object.defineProperty(e,i.key,i)}}return function(t,n,i){return n&&e(t.prototype,n),i&&e(t,i),t}}(),u=function(e){function t(e,n){!function(e,t){if(!(e instanceof t))throw new TypeError("Cannot call a class as a function")}(this,t);var i=function(e,t){if(!e)throw new ReferenceError("this hasn't been initialised - super() hasn't been called");return!t||"object"!=typeof t&&"function"!=typeof t?e:t}(this,(t.__proto__||Object.getPrototypeOf(t)).call(this));return i.resolveOptions(n),i.listenClick(e),i}return function(e,t){if("function"!=typeof t&&null!==t)throw new TypeError("Super expression must either be null or a function, not "+typeof t);e.prototype=Object.create(t&&t.prototype,{constructor:{value:e,enumerable:!1,writable:!0,configurable:!0}}),t&&(Object.setPrototypeOf?Object.setPrototypeOf(e,t):e.__proto__=t)}(t,e),c(t,[{key:"resolveOptions",value:function(){var e=arguments.length>0&&void 0!==arguments[0]?arguments[0]:{};this.action="function"==typeof e.action?e.action:this.defaultAction,this.target="function"==typeof e.target?e.target:this.defaultTarget,this.text="function"==typeof e.text?e.text:this.defaultText,this.container="object"===l(e.container)?e.container:document.body}},{key:"listenClick",value:function(e){var t=this;this.listener=(0,a.default)(e,"click",function(e){return t.onClick(e)})}},{key:"onClick",value:function(e){var t=e.delegateTarget||e.currentTarget;this.clipboardAction&&(this.clipboardAction=null),this.clipboardAction=new o.default({action:this.action(t),target:this.target(t),text:this.text(t),container:this.container,trigger:t,emitter:this})}},{key:"defaultAction",value:function(e){return f("action",e)}},{key:"defaultTarget",value:function(e){var t=f("target",e);if(t)return document.querySelector(t)}},{key:"defaultText",value:function(e){return f("text",e)}},{key:"destroy",value:function(){this.listener.destroy(),this.clipboardAction&&(this.clipboardAction.destroy(),this.clipboardAction=null)}}],[{key:"isSupported",value:function(){var e=arguments.length>0&&void 0!==arguments[0]?arguments[0]:["copy","cut"],t="string"==typeof e?[e]:e,n=!!document.queryCommandSupported;return t.forEach(function(e){n=n&&!!document.queryCommandSupported(e)}),n}}]),t}(r.default);function f(e,t){var n="data-clipboard-"+e;if(t.hasAttribute(n))return t.getAttribute(n)}e.exports=u})?i.apply(t,o):i)||(e.exports=r)},HMof:function(e,t,n){"use strict";n.r(t);var i=n("o0o1"),o=n.n(i),r=n("yXPU"),a=n.n(r),s=n("lSNA"),l=n.n(s),c=n("Kw5r"),u=n("Ddwv"),f=n.n(u);function d(e,t){var n=new f.a(t.target,{text:function(){return e}});n.on("success",function(){c.default.prototype.$message({message:"Copied!",type:"success",duration:1500}),n.off("error"),n.off("success"),n.destroy()}),n.on("error",function(){c.default.prototype.$message({message:"Copy failed",type:"error"}),n.off("error"),n.off("success"),n.destroy()}),n.onClick(t)}var v=n("rIUS"),p=n("L2JU"),m=n("9i3r");function h(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var i=Object.getOwnPropertySymbols(e);t&&(i=i.filter(function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable})),n.push.apply(n,i)}return n}function b(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?h(Object(n),!0).forEach(function(t){l()(e,t,n[t])}):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):h(Object(n)).forEach(function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))})}return e}var y={components:{RebootButton:v.a},data:function(){return{rules:{email:[{validator:this.validateEmail,trigger:"blur"}]},newTokenForm:{maxUse:1,expiresAt:""},inviteUserForm:{email:"",name:""},createTokenDialogVisible:!1,inviteUserDialogVisible:!1}},computed:b(b({},Object(p.b)(["authHost"])),{},{getLabelWidth:function(){return this.isDesktop?"100px":"85px"},inviteLink:function(){return"".concat(Object(m.a)(this.authHost),"/registration/").concat(this.newToken.token)},isDesktop:function(){return"desktop"===this.$store.state.app.device},isTokenCreated:function(){return"token"in this.newToken},loading:function(){return this.$store.state.invites.loading},newToken:function(){return this.$store.state.invites.newToken},tokens:function(){return this.$store.state.invites.inviteTokens}}),mounted:function(){this.$store.dispatch("GetNodeInfo"),this.$store.dispatch("NeedReboot"),this.$store.dispatch("FetchInviteTokens")},methods:{closeDialogWindow:function(){this.inviteUserDialogVisible=!1,this.createTokenDialogVisible=!1,this.$store.dispatch("RemoveNewToken"),this.$data.inviteUserForm.email="",this.$data.inviteUserForm.name="",this.$data.newTokenForm.maxUse=1,this.$data.newTokenForm.expiresAt=""},createToken:function(){this.$store.dispatch("GenerateInviteToken",this.$data.newTokenForm)},handleCopy:function(e){d(this.inviteLink,e)},inviteUserViaEmail:function(){var e=this;return a()(o.a.mark(function t(){return o.a.wrap(function(t){for(;;)switch(t.prev=t.next){case 0:e.$refs.inviteUserForm.validate(function(){var t=a()(o.a.mark(function t(n){return o.a.wrap(function(t){for(;;)switch(t.prev=t.next){case 0:if(!n){t.next=6;break}return t.next=3,e.$store.dispatch("InviteUserViaEmail",e.$data.inviteUserForm);case 3:e.closeDialogWindow(),t.next=8;break;case 6:return e.$message({type:"error",message:e.$t("invites.submitFormError")}),t.abrupt("return",!1);case 8:case"end":return t.stop()}},t)}));return function(e){return t.apply(this,arguments)}}());case 1:case"end":return t.stop()}},t)}))()},revokeInviteToken:function(e){this.$store.dispatch("RevokeToken",e)},validateEmail:function(e,t,n){return""===t?n(new Error(this.$t("invites.emptyEmailError"))):this.validEmail(t)?n():n(new Error(this.$t("invites.invalidEmailError")))},validEmail:function(e){return/^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/.test(e)}}},k=(n("ObxI"),n("KHd+")),g=Object(k.a)(y,function(){var e=this,t=e.$createElement,n=e._self._c||t;return n("div",{staticClass:"invites-container"},[n("div",{staticClass:"invites-header-container"},[n("h1",[e._v(e._s(e.$t("invites.inviteTokens")))]),e._v(" "),n("reboot-button")],1),e._v(" "),n("div",{staticClass:"actions-container"},[n("el-button",{staticClass:"create-invite-token",on:{click:function(t){e.createTokenDialogVisible=!0}}},[n("span",[n("i",{staticClass:"icon el-icon-plus"}),e._v("\n        "+e._s(e.$t("invites.createInviteToken"))+"\n      ")])]),e._v(" "),n("el-button",{staticClass:"invite-via-email",on:{click:function(t){e.inviteUserDialogVisible=!0}}},[n("span",[n("i",{staticClass:"icon el-icon-message"}),e._v("\n        "+e._s(e.$t("invites.inviteUserViaEmail"))+"\n      ")])])],1),e._v(" "),n("el-dialog",{attrs:{visible:e.createTokenDialogVisible,"show-close":!1,title:e.$t("invites.createInviteToken"),width:e.isTokenCreated?"60%":"30%","custom-class":"create-new-token-dialog"},on:{"update:visible":function(t){e.createTokenDialogVisible=t}}},[n("el-form",{ref:"newTokenForm",attrs:{model:e.newTokenForm,"label-width":e.getLabelWidth,"status-icon":""}},[n("el-form-item",{attrs:{label:e.$t("invites.maxUse")}},[n("el-input-number",{attrs:{min:0,size:e.isDesktop?"medium":"small",name:"maxUse"},model:{value:e.newTokenForm.maxUse,callback:function(t){e.$set(e.newTokenForm,"maxUse",t)},expression:"newTokenForm.maxUse"}})],1),e._v(" "),n("el-form-item",{attrs:{label:e.$t("invites.expiresAt")}},[n("el-date-picker",{staticClass:"pick-date",attrs:{placeholder:e.$t("invites.pickDate"),type:"date",name:"date","value-format":"yyyy-MM-dd"},model:{value:e.newTokenForm.expiresAt,callback:function(t){e.$set(e.newTokenForm,"expiresAt",t)},expression:"newTokenForm.expiresAt"}})],1)],1),e._v(" "),n("span",{attrs:{slot:"footer"},slot:"footer"},[n("el-button",{staticClass:"invites-close-dialog",on:{click:e.closeDialogWindow}},[e._v(e._s(e.$t("invites.cancel")))]),e._v(" "),n("el-button",{attrs:{type:"primary"},on:{click:e.createToken}},[e._v(e._s(e.$t("invites.create")))])],1),e._v(" "),"token"in e.newToken?n("el-card",[n("div",{staticClass:"clearfix",attrs:{slot:"header"},slot:"header"},[n("span",[e._v(e._s(e.$t("invites.tokenCreated")))])]),e._v(" "),n("el-form",{staticClass:"new-token-card",attrs:{"label-width":"85px"}},[n("el-form-item",{attrs:{label:e.$t("invites.inviteLink")}},[n("div",{staticClass:"invite-link-container"},[n("el-link",{attrs:{href:e.inviteLink,underline:!1,target:"_blank"}},[e._v("\n              "+e._s(e.inviteLink)+"\n            ")]),e._v(" "),n("el-button",{attrs:{type:"text",size:"small"},on:{click:function(t){return e.handleCopy(t)}}},[e._v(e._s(e.$t("invites.copyLink")))])],1)]),e._v(" "),n("el-form-item",{attrs:{label:e.$t("invites.token")}},[e._v("\n          "+e._s(e.newToken.token)+"\n        ")]),e._v(" "),n("el-form-item",{attrs:{label:e.$t("invites.maxUse")}},[e._v("\n          "+e._s(e.newToken.maxUse)+"\n        ")]),e._v(" "),n("el-form-item",{attrs:{label:e.$t("invites.expiresAt")}},[e._v("\n          "+e._s(e.newToken.expiresAt||"(not set)")+"\n        ")])],1)],1):e._e()],1),e._v(" "),n("el-dialog",{attrs:{visible:e.inviteUserDialogVisible,"show-close":!1,title:e.$t("invites.sendRegistration"),"custom-class":"invite-via-email-dialog"},on:{"update:visible":function(t){e.inviteUserDialogVisible=t}}},[n("div",[n("p",{staticClass:"info"},[e._v(e._s(e.$t("invites.inviteViaEmailAlert")))]),e._v(" "),n("el-form",{ref:"inviteUserForm",attrs:{model:e.inviteUserForm,rules:e.rules,"label-width":e.getLabelWidth,"status-icon":""}},[n("el-form-item",{attrs:{label:e.$t("invites.email"),prop:"email"}},[n("el-input",{attrs:{name:"email",type:"email",autofocus:""},model:{value:e.inviteUserForm.email,callback:function(t){e.$set(e.inviteUserForm,"email",t)},expression:"inviteUserForm.email"}})],1),e._v(" "),n("el-form-item",{attrs:{label:e.$t("invites.name"),prop:"name"}},[n("el-input",{attrs:{name:"name"},model:{value:e.inviteUserForm.name,callback:function(t){e.$set(e.inviteUserForm,"name",t)},expression:"inviteUserForm.name"}})],1)],1)],1),e._v(" "),n("span",{attrs:{slot:"footer"},slot:"footer"},[n("el-button",{on:{click:e.closeDialogWindow}},[e._v(e._s(e.$t("invites.cancel")))]),e._v(" "),n("el-button",{attrs:{type:"primary"},on:{click:e.inviteUserViaEmail}},[e._v(e._s(e.$t("invites.create")))])],1)]),e._v(" "),n("el-table",{directives:[{name:"loading",rawName:"v-loading",value:e.loading,expression:"loading"}],staticClass:"invite-token-table",attrs:{data:e.tokens,"default-sort":{prop:"used",order:"ascending"}}},[e.isDesktop?n("el-table-column",{attrs:{label:e.$t("invites.id"),"min-width":"60",prop:"id",sortable:""}}):e._e(),e._v(" "),n("el-table-column",{attrs:{label:e.$t("invites.token"),"min-width":e.isDesktop?320:120,prop:"token"}}),e._v(" "),e.isDesktop?n("el-table-column",{attrs:{label:e.$t("invites.expiresAt"),align:"center","header-align":"center","min-width":"110",prop:"expires_at",sortable:""}}):e._e(),e._v(" "),n("el-table-column",{attrs:{label:e.$t("invites.maxUse"),align:"center","header-align":"center","min-width":"60",prop:"max_use",sortable:""}}),e._v(" "),e.isDesktop?n("el-table-column",{attrs:{label:e.$t("invites.uses"),align:"center","header-align":"center","min-width":"60",prop:"uses"}}):e._e(),e._v(" "),n("el-table-column",{attrs:{label:e.$t("invites.used"),"min-width":e.isDesktop?60:50,align:"center","header-align":"center",prop:"used",sortable:""},scopedSlots:e._u([{key:"default",fn:function(t){return[n("el-tag",{attrs:{type:t.row.used?"danger":"success","disable-transitions":""}},[e._v("\n          "+e._s(t.row.used?e.$t("invites.used"):e.$t("invites.active"))+"\n        ")])]}}])}),e._v(" "),n("el-table-column",{attrs:{label:e.$t("invites.actions"),"min-width":e.isDesktop?100:50,align:"center","header-align":"center"},scopedSlots:e._u([{key:"default",fn:function(t){return[n("el-button",{attrs:{type:"text",size:"small"},nativeOn:{click:function(n){return e.revokeInviteToken(t.row.token)}}},[e._v("\n          "+e._s(e.$t("invites.revoke"))+"\n        ")])]}}])})],1)],1)},[],!1,null,null,null);g.options.__file="index.vue";t.default=g.exports},ObxI:function(e,t,n){"use strict";var i=n("Tykb");n.n(i).a},TiCD:function(e,t,n){var i=n("b+/x"),o=n("jFDo");e.exports=function(e,t,n){if(!e&&!t&&!n)throw new Error("Missing required arguments");if(!i.string(t))throw new TypeError("Second argument must be a String");if(!i.fn(n))throw new TypeError("Third argument must be a Function");if(i.node(e))return function(e,t,n){return e.addEventListener(t,n),{destroy:function(){e.removeEventListener(t,n)}}}(e,t,n);if(i.nodeList(e))return function(e,t,n){return Array.prototype.forEach.call(e,function(e){e.addEventListener(t,n)}),{destroy:function(){Array.prototype.forEach.call(e,function(e){e.removeEventListener(t,n)})}}}(e,t,n);if(i.string(e))return function(e,t,n){return o(document.body,e,t,n)}(e,t,n);throw new TypeError("First argument must be a String, HTMLElement, HTMLCollection, or NodeList")}},Tykb:function(e,t,n){},YDNs:function(e,t,n){var i,o,r;o=[e,n("gvr7")],void 0===(r="function"==typeof(i=function(e,t){"use strict";var n=function(e){return e&&e.__esModule?e:{default:e}}(t),i="function"==typeof Symbol&&"symbol"==typeof Symbol.iterator?function(e){return typeof e}:function(e){return e&&"function"==typeof Symbol&&e.constructor===Symbol&&e!==Symbol.prototype?"symbol":typeof e},o=function(){function e(e,t){for(var n=0;n<t.length;n++){var i=t[n];i.enumerable=i.enumerable||!1,i.configurable=!0,"value"in i&&(i.writable=!0),Object.defineProperty(e,i.key,i)}}return function(t,n,i){return n&&e(t.prototype,n),i&&e(t,i),t}}(),r=function(){function e(t){!function(e,t){if(!(e instanceof t))throw new TypeError("Cannot call a class as a function")}(this,e),this.resolveOptions(t),this.initSelection()}return o(e,[{key:"resolveOptions",value:function(){var e=arguments.length>0&&void 0!==arguments[0]?arguments[0]:{};this.action=e.action,this.container=e.container,this.emitter=e.emitter,this.target=e.target,this.text=e.text,this.trigger=e.trigger,this.selectedText=""}},{key:"initSelection",value:function(){this.text?this.selectFake():this.target&&this.selectTarget()}},{key:"selectFake",value:function(){var e=this,t="rtl"==document.documentElement.getAttribute("dir");this.removeFake(),this.fakeHandlerCallback=function(){return e.removeFake()},this.fakeHandler=this.container.addEventListener("click",this.fakeHandlerCallback)||!0,this.fakeElem=document.createElement("textarea"),this.fakeElem.style.fontSize="12pt",this.fakeElem.style.border="0",this.fakeElem.style.padding="0",this.fakeElem.style.margin="0",this.fakeElem.style.position="absolute",this.fakeElem.style[t?"right":"left"]="-9999px";var i=window.pageYOffset||document.documentElement.scrollTop;this.fakeElem.style.top=i+"px",this.fakeElem.setAttribute("readonly",""),this.fakeElem.value=this.text,this.container.appendChild(this.fakeElem),this.selectedText=(0,n.default)(this.fakeElem),this.copyText()}},{key:"removeFake",value:function(){this.fakeHandler&&(this.container.removeEventListener("click",this.fakeHandlerCallback),this.fakeHandler=null,this.fakeHandlerCallback=null),this.fakeElem&&(this.container.removeChild(this.fakeElem),this.fakeElem=null)}},{key:"selectTarget",value:function(){this.selectedText=(0,n.default)(this.target),this.copyText()}},{key:"copyText",value:function(){var e=void 0;try{e=document.execCommand(this.action)}catch(t){e=!1}this.handleResult(e)}},{key:"handleResult",value:function(e){this.emitter.emit(e?"success":"error",{action:this.action,text:this.selectedText,trigger:this.trigger,clearSelection:this.clearSelection.bind(this)})}},{key:"clearSelection",value:function(){this.trigger&&this.trigger.focus(),window.getSelection().removeAllRanges()}},{key:"destroy",value:function(){this.removeFake()}},{key:"action",set:function(){var e=arguments.length>0&&void 0!==arguments[0]?arguments[0]:"copy";if(this._action=e,"copy"!==this._action&&"cut"!==this._action)throw new Error('Invalid "action" value, use either "copy" or "cut"')},get:function(){return this._action}},{key:"target",set:function(e){if(void 0!==e){if(!e||"object"!==(void 0===e?"undefined":i(e))||1!==e.nodeType)throw new Error('Invalid "target" value, use a valid Element');if("copy"===this.action&&e.hasAttribute("disabled"))throw new Error('Invalid "target" attribute. Please use "readonly" instead of "disabled" attribute');if("cut"===this.action&&(e.hasAttribute("readonly")||e.hasAttribute("disabled")))throw new Error('Invalid "target" attribute. You can\'t cut text from elements with "readonly" or "disabled" attributes');this._target=e}},get:function(){return this._target}}]),e}();e.exports=r})?i.apply(t,o):i)||(e.exports=r)},"b+/x":function(e,t){t.node=function(e){return void 0!==e&&e instanceof HTMLElement&&1===e.nodeType},t.nodeList=function(e){var n=Object.prototype.toString.call(e);return void 0!==e&&("[object NodeList]"===n||"[object HTMLCollection]"===n)&&"length"in e&&(0===e.length||t.node(e[0]))},t.string=function(e){return"string"==typeof e||e instanceof String},t.fn=function(e){return"[object Function]"===Object.prototype.toString.call(e)}},gvr7:function(e,t){e.exports=function(e){var t;if("SELECT"===e.nodeName)e.focus(),t=e.value;else if("INPUT"===e.nodeName||"TEXTAREA"===e.nodeName){var n=e.hasAttribute("readonly");n||e.setAttribute("readonly",""),e.select(),e.setSelectionRange(0,e.value.length),n||e.removeAttribute("readonly"),t=e.value}else{e.hasAttribute("contenteditable")&&e.focus();var i=window.getSelection(),o=document.createRange();o.selectNodeContents(e),i.removeAllRanges(),i.addRange(o),t=i.toString()}return t}},jFDo:function(e,t,n){var i=n("lNia");function o(e,t,n,o,r){var a=function(e,t,n,o){return function(n){n.delegateTarget=i(n.target,t),n.delegateTarget&&o.call(e,n)}}.apply(this,arguments);return e.addEventListener(n,a,r),{destroy:function(){e.removeEventListener(n,a,r)}}}e.exports=function(e,t,n,i,r){return"function"==typeof e.addEventListener?o.apply(null,arguments):"function"==typeof n?o.bind(null,document).apply(null,arguments):("string"==typeof e&&(e=document.querySelectorAll(e)),Array.prototype.map.call(e,function(e){return o(e,t,n,i,r)}))}},lNia:function(e,t){var n=9;if("undefined"!=typeof Element&&!Element.prototype.matches){var i=Element.prototype;i.matches=i.matchesSelector||i.mozMatchesSelector||i.msMatchesSelector||i.oMatchesSelector||i.webkitMatchesSelector}e.exports=function(e,t){for(;e&&e.nodeType!==n;){if("function"==typeof e.matches&&e.matches(t))return e;e=e.parentNode}}},wOJ8:function(e,t){function n(){}n.prototype={on:function(e,t,n){var i=this.e||(this.e={});return(i[e]||(i[e]=[])).push({fn:t,ctx:n}),this},once:function(e,t,n){var i=this;function o(){i.off(e,o),t.apply(n,arguments)}return o._=t,this.on(e,o,n)},emit:function(e){for(var t=[].slice.call(arguments,1),n=((this.e||(this.e={}))[e]||[]).slice(),i=0,o=n.length;i<o;i++)n[i].fn.apply(n[i].ctx,t);return this},off:function(e,t){var n=this.e||(this.e={}),i=n[e],o=[];if(i&&t)for(var r=0,a=i.length;r<a;r++)i[r].fn!==t&&i[r].fn._!==t&&o.push(i[r]);return o.length?n[e]=o:delete n[e],this}},e.exports=n,e.exports.TinyEmitter=n}}]);
//# sourceMappingURL=chunk-2658.c0cbe1ca.js.map