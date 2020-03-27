define(["browser","connectionManager","cardBuilder","registrationServices","appSettings","dom","apphost","layoutManager","imageLoader","globalize","itemShortcuts","itemHelper","appRouter","emby-button","paper-icon-button-light","emby-itemscontainer","emby-scroller","emby-linkbutton"],function(browser,connectionManager,cardBuilder,registrationServices,appSettings,dom,appHost,layoutManager,imageLoader,globalize,itemShortcuts,itemHelper,appRouter){"use strict";function getDefaultSection(index){switch(index){case 0:return"smalllibrarytiles";case 1:return"resume";case 2:return"resumeaudio";case 3:return"livetv";case 4:return"nextup";case 5:return"latestmedia";case 6:return"none";default:return""}}function resume(elem,options){var i,length,elems=elem.querySelectorAll(".itemsContainer"),promises=[];for(i=0,length=elems.length;i<length;i++)promises.push(elems[i].resume(options));var promise=Promise.all(promises);return options&&!1===options.returnPromise?promises[0]:promise}function loadSection(page,apiClient,user,userSettings,allSections,index){var section=allSections[index],elem=(apiClient.getCurrentUserId(),page.querySelector(".section"+index));if("latestmedia"===section)return function(elem,apiClient,user){return getUserViews(apiClient,apiClient.getCurrentUserId()).then(function(userViews){elem.classList.remove("verticalSection");for(var excludeViewTypes=["playlists","livetv","boxsets","channels"],i=0,length=userViews.length;i<length;i++){var item=userViews[i];if(-1===user.Configuration.LatestItemsExcludes.indexOf(item.Id)&&-1===excludeViewTypes.indexOf(item.CollectionType||[])){var frag=document.createElement("div");frag.classList.add("verticalSection"),frag.classList.add("hide"),elem.appendChild(frag),renderLatestSection(frag,apiClient,item)}}})}(elem,apiClient,user);if("librarytiles"===section||"smalllibrarytiles"===section||"smalllibrarytiles-automobile"===section||"librarytiles-automobile"===section)return function(elem,apiClient,userSettings,index){var html="";html+='<div class="sectionTitleContainer sectionTitleContainer-cards">',html+='<h2 class="sectionTitle sectionTitle-cards padded-left">'+globalize.translate("HeaderMyMedia")+"</h2>",layoutManager.tv||(html+='<button type="button" is="paper-icon-button-light" class="sectionTitleIconButton btnHomeScreenSettings noautofocus"><i class="md-icon button-icon">&#xE5D3;</i></button>');html+="</div>";var itemsContainerClass="itemsContainer scrollSlider focuscontainer-x padded-left padded-right";!layoutManager.tv&&index<2&&(itemsContainerClass+=" itemsContainer-finepointerwrap");html+='<div is="emby-scroller" class="padded-top-focusscale padded-bottom-focusscale" data-mousewheel="false" data-centerfocus="true"><div is="emby-itemscontainer" class="'+itemsContainerClass+'">',html+="</div>",html+="</div>",elem.classList.add("hide"),elem.innerHTML=html,bindHomeScreenSettingsIcon(elem,apiClient.getCurrentUserId(),apiClient.serverId());var itemsContainer=elem.querySelector(".itemsContainer");itemsContainer.fetchData=getUserViewsFetchFn(apiClient.serverId()),itemsContainer.getItemsHtml=getLibraryTilesHtml,itemsContainer.parentContainer=elem}(elem,apiClient,0,index);if("librarybuttons"===section)return function(elem,apiClient){var html="";html+='<div class="sectionTitleContainer sectionTitleContainer-cards">',html+='<h2 class="sectionTitle sectionTitle-cards padded-left">'+globalize.translate("HeaderMyMedia")+"</h2>",layoutManager.tv||(html+='<button type="button" is="paper-icon-button-light" class="sectionTitleIconButton btnHomeScreenSettings noautofocus"><i class="md-icon button-icon">&#xE5D3;</i></button>');html+="</div>",html+='<div is="emby-itemscontainer" class="itemsContainer padded-left padded-right vertical-wrap focuscontainer-x" data-multiselect="false">',html+="</div>",elem.classList.add("hide"),elem.innerHTML=html,bindHomeScreenSettingsIcon(elem,apiClient.getCurrentUserId(),apiClient.serverId());var itemsContainer=elem.querySelector(".itemsContainer");itemsContainer.fetchData=getUserViewsFetchFn(apiClient.serverId()),itemsContainer.getItemsHtml=getLibraryButtonItemsHtml,itemsContainer.parentContainer=elem}(elem,apiClient);if("resume"===section)!function(elem,apiClient){var html="";html+='<h2 class="sectionTitle sectionTitle-cards padded-left">'+globalize.translate("HeaderContinueWatching")+"</h2>",html+='<div is="emby-scroller" data-mousewheel="false" data-centerfocus="true" class="padded-top-focusscale padded-bottom-focusscale"><div is="emby-itemscontainer" class="itemsContainer scrollSlider focuscontainer-x padded-left padded-right" data-monitor="videoplayback,markplayed">',html+="</div>",html+="</div>",elem.classList.add("hide"),elem.innerHTML=html;var itemsContainer=elem.querySelector(".itemsContainer");itemsContainer.fetchData=function(serverId){return function(){var apiClient=connectionManager.getApiClient(serverId);return apiClient.getResumableItems(apiClient.getCurrentUserId(),{Limit:12,Recursive:!0,Fields:"PrimaryImageAspectRatio,BasicSyncInfo,ProductionYear",ImageTypeLimit:1,EnableImageTypes:"Primary,Backdrop,Thumb",EnableTotalRecordCount:!1,MediaTypes:"Video"})}}(apiClient.serverId()),itemsContainer.getItemsHtml=getContinueWatchingItemsHtml,itemsContainer.parentContainer=elem}(elem,apiClient);else if("resumeaudio"===section)!function(elem,apiClient){var html="";html+='<h2 class="sectionTitle sectionTitle-cards padded-left">'+globalize.translate("HeaderContinueListening")+"</h2>",html+='<div is="emby-scroller" data-mousewheel="false" data-centerfocus="true" class="padded-top-focusscale padded-bottom-focusscale"><div is="emby-itemscontainer" class="itemsContainer scrollSlider focuscontainer-x padded-left padded-right" data-monitor="audioplayback,markplayed">',html+="</div>",html+="</div>",elem.classList.add("hide"),elem.innerHTML=html;var itemsContainer=elem.querySelector(".itemsContainer");itemsContainer.fetchData=function(serverId){return function(){var apiClient=connectionManager.getApiClient(serverId);return apiClient.getResumableItems(apiClient.getCurrentUserId(),{Limit:12,Recursive:!0,Fields:"PrimaryImageAspectRatio,BasicSyncInfo,ProductionYear",ImageTypeLimit:1,EnableImageTypes:"Primary,Backdrop,Thumb",EnableTotalRecordCount:!1,MediaTypes:"Audio"})}}(apiClient.serverId()),itemsContainer.getItemsHtml=getContinueListeningItemsHtml,itemsContainer.parentContainer=elem}(elem,apiClient);else if("activerecordings"===section)!function(elem,activeRecordingsOnly,apiClient){var title=activeRecordingsOnly?globalize.translate("HeaderActiveRecordings"):globalize.translate("HeaderLatestRecordings"),html="";html+='<div class="sectionTitleContainer sectionTitleContainer-cards">',html+='<h2 class="sectionTitle sectionTitle-cards padded-left">'+title+"</h2>",layoutManager.tv;html+="</div>",html+='<div is="emby-scroller" data-mousewheel="false" data-centerfocus="true" class="padded-top-focusscale padded-bottom-focusscale"><div is="emby-itemscontainer" class="itemsContainer scrollSlider focuscontainer-x padded-left padded-right">',html+="</div>",html+="</div>",elem.classList.add("hide"),elem.innerHTML=html;var itemsContainer=elem.querySelector(".itemsContainer");itemsContainer.fetchData=function(serverId,activeRecordingsOnly){return function(){var apiClient=connectionManager.getApiClient(serverId);return apiClient.getLiveTvRecordings({userId:apiClient.getCurrentUserId(),Limit:12,Fields:"PrimaryImageAspectRatio,BasicSyncInfo,ProductionYear",EnableTotalRecordCount:!1,IsLibraryItem:!!activeRecordingsOnly&&null,IsInProgress:!!activeRecordingsOnly||null})}}(apiClient.serverId(),activeRecordingsOnly),itemsContainer.getItemsHtml=function(activeRecordingsOnly){return function(items){return cardBuilder.getCardsHtml({items:items,shape:"autooverflow",showTitle:!0,showParentTitle:!0,lazy:!0,showDetailsMenu:!0,centerText:!0,overlayText:!1,showYear:!0,lines:2,overlayPlayButton:!activeRecordingsOnly,preferThumb:!0,cardLayout:!1,overlayMoreButton:activeRecordingsOnly,action:activeRecordingsOnly?"none":null,centerPlayButton:activeRecordingsOnly})}}(activeRecordingsOnly),itemsContainer.parentContainer=elem}(elem,!0,apiClient);else{if("nextup"!==section)return"onnow"===section||"livetv"===section?function(elem,apiClient,user){if(!user.Policy.EnableLiveTvAccess)return Promise.resolve();var promises=[];promises.push(registrationServices.validateFeature("livetv",{viewOnly:!0,showDialog:!1}).then(function(){return!0},function(){return!1}));apiClient.getCurrentUserId();return promises.push(apiClient.getLiveTvChannels({userId:apiClient.getCurrentUserId(),limit:1,ImageTypeLimit:1,EnableTotalRecordCount:!1,EnableImages:!1,EnableUserData:!1})),Promise.all(promises).then(function(responses){var registered=responses[0],result=responses[1],html="";if(result.Items.length&&registered){elem.classList.remove("padded-left"),elem.classList.remove("padded-right"),elem.classList.remove("padded-bottom"),elem.classList.remove("verticalSection"),html+='<div class="verticalSection">',html+='<div class="sectionTitleContainer sectionTitleContainer-cards padded-left">',html+='<h2 class="sectionTitle sectionTitle-cards">'+globalize.translate("LiveTV")+"</h2>",html+="</div>",html+='<div is="emby-scroller" class="padded-top-focusscale padded-bottom-focusscale" data-mousewheel="false" data-centerfocus="true" data-scrollbuttons="false">',html+='<div class="scrollSlider padded-left padded-right padded-top padded-bottom focuscontainer-x">',html+='<a style="margin-left:.8em;margin-right:0;" is="emby-linkbutton" href="'+appRouter.getRouteUrl("livetv",{serverId:apiClient.serverId(),section:"programs"})+'" class="raised"><span>'+globalize.translate("Programs")+"</span></a>",html+='<a style="margin-left:.5em;margin-right:0;" is="emby-linkbutton" href="'+appRouter.getRouteUrl("livetv",{serverId:apiClient.serverId(),section:"guide"})+'" class="raised"><span>'+globalize.translate("Guide")+"</span></a>",html+='<a style="margin-left:.5em;margin-right:0;" is="emby-linkbutton" href="'+appRouter.getRouteUrl("recordedtv",{serverId:apiClient.serverId()})+'" class="raised"><span>'+globalize.translate("Recordings")+"</span></a>",html+='<a style="margin-left:.5em;margin-right:0;" is="emby-linkbutton" href="'+appRouter.getRouteUrl("livetv",{serverId:apiClient.serverId(),section:"dvrschedule"})+'" class="raised"><span>'+globalize.translate("Schedule")+"</span></a>",html+="</div>",html+="</div>",html+="</div>",html+="</div>",html+='<div class="verticalSection">',html+='<div class="sectionTitleContainer sectionTitleContainer-cards padded-left">',layoutManager.tv?html+='<h2 class="sectionTitle sectionTitle-cards">'+globalize.translate("HeaderOnNow")+"</h2>":(html+='<a is="emby-linkbutton" href="'+appRouter.getRouteUrl("livetv",{serverId:apiClient.serverId(),section:"onnow"})+'" class="more button-flat button-flat-mini sectionTitleTextButton">',html+='<h2 class="sectionTitle sectionTitle-cards">',html+=globalize.translate("HeaderOnNow"),html+='<i class="md-icon">&#xE5CC;</i></h2>',html+="</a>"),html+="</div>",html+='<div is="emby-scroller" data-mousewheel="false" data-centerfocus="true" class="padded-top-focusscale padded-bottom-focusscale"><div is="emby-itemscontainer" class="itemsContainer scrollSlider focuscontainer-x padded-left padded-right" data-refreshinterval="300000" data-multiselect="false">',html+="</div>",html+="</div>",html+="</div>",elem.innerHTML=html;var itemsContainer=elem.querySelector(".itemsContainer");itemsContainer.parentContainer=elem,itemsContainer.fetchData=function(serverId){return function(){var apiClient=connectionManager.getApiClient(serverId);return apiClient.getLiveTvChannels({userId:apiClient.getCurrentUserId(),IsAiring:!0,limit:24,ImageTypeLimit:1,EnableImageTypes:"Primary,Thumb,Backdrop",EnableTotalRecordCount:!1,Fields:"ProgramPrimaryImageAspectRatio",EnableUserData:!1,SortBy:apiClient.isMinServerVersion("4.4.0.20")?"ChannelNumber,SortName":null})}}(apiClient.serverId()),itemsContainer.getItemsHtml=getOnNowItemsHtml}else result.Items.length&&!registered&&(elem.classList.add("padded-left"),elem.classList.add("padded-right"),elem.classList.add("padded-bottom"),html+='<h2 class="sectionTitle">'+globalize.translate("LiveTvRequiresUnlock")+"</h2>",elem.innerHTML=html);!function(elem){var btnUnlock=elem.querySelector(".btnUnlock");btnUnlock&&btnUnlock.addEventListener("click",function(e){registrationServices.validateFeature("livetv",{viewOnly:!0}).then(function(){dom.parentWithClass(elem,"homeSectionsContainer").dispatchEvent(new CustomEvent("settingschange",{cancelable:!1}))})})}(elem)})}(elem,apiClient,user):(elem.innerHTML="",Promise.resolve());!function(elem,apiClient){var html="";html+='<div class="sectionTitleContainer sectionTitleContainer-cards padded-left">',layoutManager.tv?html+='<h2 class="sectionTitle sectionTitle-cards">'+globalize.translate("HeaderNextUp")+"</h2>":(html+='<a is="emby-linkbutton" href="'+appRouter.getRouteUrl("nextup",{serverId:apiClient.serverId()})+'" class="button-flat button-flat-mini sectionTitleTextButton">',html+='<h2 class="sectionTitle sectionTitle-cards">',html+=globalize.translate("HeaderNextUp"),html+='<i class="md-icon">&#xE5CC;</i></h2>',html+="</a>");html+="</div>",html+='<div is="emby-scroller" data-mousewheel="false" data-centerfocus="true" class="padded-top-focusscale padded-bottom-focusscale"><div is="emby-itemscontainer" class="itemsContainer scrollSlider focuscontainer-x padded-left padded-right" data-monitor="videoplayback,markplayed">',html+="</div>",html+="</div>",elem.classList.add("hide"),elem.innerHTML=html;var itemsContainer=elem.querySelector(".itemsContainer");itemsContainer.fetchData=function(serverId){return function(){var apiClient=connectionManager.getApiClient(serverId);return apiClient.getNextUpEpisodes({Limit:24,Fields:"PrimaryImageAspectRatio,SeriesInfo,DateCreated,BasicSyncInfo",UserId:apiClient.getCurrentUserId(),ImageTypeLimit:1,EnableImageTypes:"Primary,Backdrop,Banner,Thumb",EnableTotalRecordCount:!1})}}(apiClient.serverId()),itemsContainer.getItemsHtml=getNextUpItemsHtml,itemsContainer.parentContainer=elem}(elem,apiClient)}return Promise.resolve()}function getUserViews(apiClient,userId){return apiClient.getUserViews({},userId||apiClient.getCurrentUserId()).then(function(result){return result.Items})}function getLibraryButtonItemsHtml(items){for(var html="",i=0,length=items.length;i<length;i++){var item=items[i],icon=cardBuilder.getDefaultIcon(item);html+='<div class="smallBackdropCard flex"><a is="emby-linkbutton" href="'+appRouter.getRouteUrl(item)+'" class="raised block flex-grow" style="margin:.5em;text-align:left;"><i class="md-icon">'+icon+'</i><span style="margin-left:.5em;">'+item.Name+"</span></a></div>"}return html}function getUserViewsFetchFn(serverId){return function(){var apiClient=connectionManager.getApiClient(serverId);return getUserViews(apiClient,apiClient.getCurrentUserId())}}function getAppInfo(){var cacheKey="lastappinfopresent5",lastDatePresented=parseInt(appSettings.get(cacheKey)||"0");return lastDatePresented?Date.now()-lastDatePresented<1728e5?Promise.resolve(""):registrationServices.validateFeature("dvr",{showDialog:!1,viewOnly:!0}).then(function(){return appSettings.set(cacheKey,Date.now()),""},function(){return appSettings.set(cacheKey,Date.now()),function(){var html="";return html+='<div class="sectionTitleContainer sectionTitleContainer-cards">',html+='<h2 class="sectionTitle sectionTitle-cards padded-left">Discover Emby Premiere</h2>',html+="</div>",html+='<div class="padded-left padded-right">',html+='<p class="sectionTitle-cards">Enjoy Emby DVR, get free access to Emby apps, and more.</p>',html+='<div class="itemsContainer vertical-wrap" is="emby-itemscontainer">',html+=getCard("https://raw.githubusercontent.com/MediaBrowser/Emby.Resources/master/apps/theater1.png"),html+=getCard("https://raw.githubusercontent.com/MediaBrowser/Emby.Resources/master/apps/theater2.png"),html+=getCard("https://raw.githubusercontent.com/MediaBrowser/Emby.Resources/master/apps/theater3.png"),html+="</div>",html+="</div>"}()}):(appSettings.set(cacheKey,Date.now()),Promise.resolve(""))}function getCard(img,shape){var html='<div class="card scalableCard '+(shape=shape||"backdropCard")+" "+shape+'-scalable"><div class="cardBox"><div class="cardScalable"><div class="cardPadder cardPadder-backdrop"></div>';return html+='<div class="cardContent">',html+='<div class="cardImage" loading="lazy" style="background-image:url('+img+');"></div>',html+="</div>",html+="</div></div></div>"}function renderLatestSection(elem,apiClient,parent){var html="";html+='<div class="sectionTitleContainer sectionTitleContainer-cards padded-left">',layoutManager.tv?html+='<h2 class="sectionTitle sectionTitle-cards">'+globalize.translate("LatestFromLibrary",parent.Name)+"</h2>":(html+='<a is="emby-linkbutton" href="'+appRouter.getRouteUrl(parent,{section:"latest"})+'" class="more button-flat button-flat-mini sectionTitleTextButton">',html+='<h2 class="sectionTitle sectionTitle-cards">',html+=globalize.translate("LatestFromLibrary",parent.Name),html+='<i class="md-icon">&#xE5CC;</i></h2>',html+="</a>"),html+="</div>";var monitor="music"===parent.CollectionType||"audiobooks"===parent.CollectionType?"markplayed":"videoplayback,markplayed";html+='<div data-parentid="'+parent.Id+'" is="emby-scroller" data-mousewheel="false" data-centerfocus="true" class="padded-top-focusscale padded-bottom-focusscale"><div is="emby-itemscontainer" class="itemsContainer scrollSlider focuscontainer-x padded-left padded-right" data-monitor="'+monitor+'">',html+="</div>",html+="</div>",elem.innerHTML=html;var itemsContainer=elem.querySelector(".itemsContainer");itemsContainer.fetchData=function(serverId,parentId,collectionType){return function(){var apiClient=connectionManager.getApiClient(serverId),limit=16;"music"===collectionType&&(limit=30);var options={Limit:limit,Fields:"PrimaryImageAspectRatio,BasicSyncInfo,ProductionYear,Status,EndDate",ImageTypeLimit:1,EnableImageTypes:"Primary,Backdrop,Thumb",ParentId:parentId};return apiClient.getLatestItems(options)}}(apiClient.serverId(),parent.Id,parent.CollectionType),itemsContainer.getItemsHtml=function(itemType,viewType){return function(items){return cardBuilder.getCardsHtml({items:items,shape:"autooverflow",preferThumb:"auto",showUnplayedIndicator:!1,showChildCountIndicator:!0,context:"home",overlayText:!1,centerText:!0,overlayPlayButton:"photos"!==viewType,showTitle:"photos"!==viewType,showYear:"movies"===viewType||"tvshows"===viewType||!viewType,showParentTitle:"music"===viewType||"tvshows"===viewType||!viewType,lines:2})}}(parent.Type,parent.CollectionType),itemsContainer.parentContainer=elem}function bindHomeScreenSettingsIcon(elem,userId,serverId){var btnHomeScreenSettings=elem.querySelector(".btnHomeScreenSettings");btnHomeScreenSettings&&btnHomeScreenSettings.addEventListener("click",function(){appRouter.show("settings/homescreen.html?userId="+userId+"&serverId="+serverId)})}function getDownloadItemsHtml(items){return cardBuilder.getCardsHtml({items:items,preferThumb:"auto",inheritThumb:!1,shape:"autooverflow",overlayText:!1,showTitle:!0,showParentTitle:!0,lazy:!0,showDetailsMenu:!0,overlayPlayButton:!0,context:"home",centerText:!0,allowBottomPadding:!1,showYear:!0,lines:2})}function getLibraryTilesHtml(items){return cardBuilder.getCardsHtml({items:items,shape:"smallBackdrop",showTitle:!0,centerText:!0,overlayText:!1,lazy:!0,transition:!1,hoverPlayButton:!1})}function loadAppInfoSection(elem){return elem.classList.add("hide"),getAppInfo().then(function(html){elem.innerHTML=html,function(elem){var itemsContainer=elem.querySelector(".itemsContainer");itemsContainer&&itemsContainer.addEventListener("click",function(e){dom.parentWithClass(e.target,"card")&&registrationServices.showPremiereInfo()})}(elem),html?elem.classList.remove("hide"):elem.classList.add("hide")}),Promise.resolve()}function loadDownloadsSection(elem,apiClient,user){if(elem.classList.add("hide"),!appHost.supports("sync")||!user.Policy.EnableContentDownloading)return Promise.resolve();var html="";html+='<div class="sectionTitleContainer sectionTitleContainer-cards padded-left padded-right">',html+='<a is="emby-linkbutton" href="'+appRouter.getRouteUrl("downloads")+'" class="more button-flat button-flat-mini sectionTitleTextButton">',html+='<h2 class="sectionTitle sectionTitle-cards">',html+=globalize.translate("Downloads"),html+='<i class="md-icon">&#xE5CC;</i></h2>',html+="</a>",layoutManager.tv||(html+='<a is="emby-linkbutton" href="'+appRouter.getRouteUrl("managedownloads")+'" class="sectionTitleIconButton"><i class="md-icon">&#xE8B8;</i></a>'),html+="</div>",html+='<div is="emby-scroller" class="padded-top-focusscale padded-bottom-focusscale" data-mousewheel="false" data-centerfocus="true"><div is="emby-itemscontainer" class="itemsContainer scrollSlider focuscontainer-x padded-left padded-right">',html+="</div>",html+="</div>",elem.innerHTML=html;var itemsContainer=elem.querySelector(".itemsContainer");itemsContainer.fetchData=function(serverId){return function(){var apiClient=connectionManager.getApiClient(serverId);return apiClient.getLatestOfflineItems?apiClient.getLatestOfflineItems({Limit:20,Filters:"IsNotFolder"}):Promise.resolve([])}}(apiClient.serverId()),itemsContainer.getItemsHtml=getDownloadItemsHtml,itemsContainer.parentContainer=elem}function getContinueWatchingItemsHtml(items){return cardBuilder.getCardsHtml({items:items,preferThumb:!0,shape:"backdrop",overlayText:!1,showTitle:!0,showParentTitle:!0,lazy:!0,showDetailsMenu:!0,overlayPlayButton:!0,context:"home",centerText:!0,allowBottomPadding:!1,cardLayout:!1,showYear:!0,lines:2})}function getContinueListeningItemsHtml(items){return cardBuilder.getCardsHtml({items:items,preferThumb:!0,shape:"backdrop",overlayText:!1,showTitle:!0,showParentTitle:!0,lazy:!0,showDetailsMenu:!0,overlayPlayButton:!0,context:"home",centerText:!0,allowBottomPadding:!1,cardLayout:!1,showYear:!0,lines:2})}function getOnNowItemsHtml(items){return cardBuilder.getCardsHtml({items:items,preferThumb:"auto",inheritThumb:!1,shape:"autooverflow",centerText:!0,overlayText:!1,lines:3,showTitle:!1,showCurrentProgramParentTitle:!0,showCurrentProgramTitle:!0,showCurrentProgramTime:!0,showCurrentProgramImage:!0,showAirDateTime:!1,showParentTitle:!1,overlayPlayButton:!0,defaultShape:"portrait",action:"programlink",multiSelect:!1})}function getNextUpItemsHtml(items){return cardBuilder.getCardsHtml({items:items,preferThumb:!0,shape:"backdrop",overlayText:!1,showTitle:!0,showParentTitle:!0,lazy:!0,overlayPlayButton:!0,context:"home",centerText:!0,cardLayout:!1})}return{getDefaultSection:getDefaultSection,loadSections:function(elem,apiClient,user,userSettings){var i,length,html="";for(i=0,length=7;i<length;i++)html+='<div class="verticalSection section'+i+'"></div>',0===i&&(html+='<div class="verticalSection section-downloads hide"></div>',html+='<div class="verticalSection section-appinfo hide"></div>');elem.innerHTML=html,elem.classList.add("homeSectionsContainer");var promises=[],sections=function(userSettings,sectionCount){for(var sections=[],i=0,length=sectionCount;i<length;i++){var section=userSettings.get("homesection"+i)||getDefaultSection(i);"folders"===section&&(section=getDefaultSection(0)),sections.push(section)}return sections}(userSettings,7);for(i=0,length=sections.length;i<length;i++)promises.push(loadSection(elem,apiClient,user,userSettings,sections,i)),0===i&&(promises.push(loadDownloadsSection(elem.querySelector(".section-downloads"),apiClient,user)),promises.push(loadAppInfoSection(elem.querySelector(".section-appinfo"),apiClient)));return Promise.all(promises).then(function(){return resume(elem,{refresh:!0,returnPromise:!1})})},destroySections:function(elem){var i,length,elems=elem.querySelectorAll(".itemsContainer");for(i=0,length=elems.length;i<length;i++)elems[i].fetchData=null,elems[i].parentContainer=null,elems[i].getItemsHtml=null;elem.innerHTML=""},pause:function(elem){var i,length,elems=elem.querySelectorAll(".itemsContainer");for(i=0,length=elems.length;i<length;i++)elems[i].pause()},resume:resume}});
