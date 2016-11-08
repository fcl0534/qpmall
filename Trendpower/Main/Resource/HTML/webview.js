 var script = document.createElement('script');   
 script.type = 'text/javascript';   
 script.text = function ResizeImages() {    
     var myimg,oldwidth;  
     var maxwidth=640; //缩放系数
     for(i=0;i <document.images.length;i++){   
         myimg = document.images[i];  
         if(myimg.width > maxwidth){   
             oldwidth = myimg.width;   
             myimg.width = maxwidth;   
             myimg.height = myimg.height * (maxwidth/oldwidth);   
         }   
     }   
 };   
 document.getElementsByTagName('head')[0].appendChild(script);];   
  