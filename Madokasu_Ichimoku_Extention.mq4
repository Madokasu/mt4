//+------------------------------------------------------------------+
//|                                   Editid from       Ichimoku.mq4 |
//+------------------------------------------------------------------+
#property link      "https://madokasu-fx.blogspot.com"

#property indicator_chart_window
#property indicator_buffers 7
#property indicator_color1 Red
#property indicator_color2 Blue
#property indicator_color3 SandyBrown
#property indicator_color4 Thistle
#property indicator_color5 Lime
#property indicator_color6 SandyBrown
#property indicator_color7 Thistle
#property indicator_width1 2
#property indicator_width2 2
#property indicator_width5 2
//---- input parameters
extern int Tenkan=9;
extern int Kijun=26;
extern int Senkou=52;
extern color GuideText_color=White;
extern int GuideText_corner=1;
extern int TurningPoint_margin=2;
extern double ValueEqual_marginPoint=0.5;
//---- buffers
double Tenkan_Buffer[];
double Kijun_Buffer[];
double SpanA_Buffer[];
double SpanB_Buffer[];
double Chinkou_Buffer[];
double SpanA2_Buffer[];
double SpanB2_Buffer[];
//----
int a_begin;
string obj_prefix="Ichimoku+guide";
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
/*
//----
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,Tenkan_Buffer);
   SetIndexDrawBegin(0,Tenkan-1);
   SetIndexLabel(0,"転換線");
//----
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,Kijun_Buffer);
   SetIndexDrawBegin(1,Kijun-1);
   SetIndexLabel(1,"基準線");
//----
   a_begin=Kijun; if(a_begin<Tenkan) a_begin=Tenkan;
   SetIndexStyle(2,DRAW_HISTOGRAM,STYLE_DOT);
   SetIndexBuffer(2,SpanA_Buffer);
   SetIndexDrawBegin(2,Kijun+a_begin-1);
   SetIndexShift(2,Kijun-1);
   SetIndexLabel(2,NULL);
   SetIndexStyle(5,DRAW_LINE,STYLE_DOT);
   SetIndexBuffer(5,SpanA2_Buffer);
   SetIndexDrawBegin(5,Kijun+a_begin-1);
   SetIndexShift(5,Kijun-1);
   SetIndexLabel(5,"先行スパン1");
//----
   SetIndexStyle(3,DRAW_HISTOGRAM,STYLE_DOT);
   SetIndexBuffer(3,SpanB_Buffer);
   SetIndexDrawBegin(3,Kijun+Senkou-1);
   SetIndexShift(3,Kijun-1);
   SetIndexLabel(3,NULL);
   SetIndexStyle(6,DRAW_LINE,STYLE_DOT);
   SetIndexBuffer(6,SpanB2_Buffer);
   SetIndexDrawBegin(6,Kijun+Senkou-1);
   SetIndexShift(6,Kijun-1);
   SetIndexLabel(6,"先行スパン2");
//----
   SetIndexStyle(4,DRAW_LINE);
   SetIndexBuffer(4,Chinkou_Buffer);
   SetIndexShift(4,1-Kijun);
   SetIndexLabel(4,"遅行スパン");
//----
*/
   if(GuideText_corner < 0) GuideText_corner = 0;
   if(GuideText_corner > 3) GuideText_corner = 3;

   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
// delete guides
   int objnameprefix_length=StringLen(obj_prefix);
   for(int i=ObjectsTotal()-1; i>=0; i--) 
     {
      string label=ObjectName(i);
      if(StringSubstr(label,0,objnameprefix_length)==obj_prefix)
         ObjectDelete(label);
     }
  }
//+------------------------------------------------------------------+
//| Ichimoku Kinko Hyo                                               |
//+------------------------------------------------------------------+
int start()
  {
   int    i,k;
   int    counted_bars=IndicatorCounted();
   double high,low,price;
//----
   if(Bars<=Tenkan || Bars<=Kijun || Bars<=Senkou) return(0);
//---- initial zero
   if(counted_bars<1)
     {
      for(i=1;i<=Tenkan;i++)    Tenkan_Buffer[Bars-i]=0;
      for(i=1;i<=Kijun;i++)     Kijun_Buffer[Bars-i]=0;
      for(i=1;i<=a_begin;i++) { SpanA_Buffer[Bars-i]=0; SpanA2_Buffer[Bars-i]=0; }
      for(i=1;i<=Senkou;i++)  { SpanB_Buffer[Bars-i]=0; SpanB2_Buffer[Bars-i]=0; }
     }
//---- Tenkan Sen
   i=Bars-Tenkan;
   if(counted_bars>Tenkan) i=Bars-counted_bars-1;
   while(i>=0)
     {
      high=High[i]; low=Low[i]; k=i-1+Tenkan;
      while(k>=i)
        {
         price=High[k];
         if(high<price) high=price;
         price=Low[k];
         if(low>price) low=price;
         k--;
        }
      Tenkan_Buffer[i]=(high+low)/2;
      i--;
     }
//---- Kijun Sen
   i=Bars-Kijun;
   if(counted_bars>Kijun) i=Bars-counted_bars-1;
   while(i>=0)
     {
      high=High[i]; low=Low[i]; k=i-1+Kijun;
      while(k>=i)
        {
         price=High[k];
         if(high<price) high=price;
         price=Low[k];
         if(low>price) low=price;
         k--;
        }
      Kijun_Buffer[i]=(high+low)/2;
      i--;
     }
//---- Senkou Span A
   i=Bars-a_begin+1;
   if(counted_bars>a_begin-1) i=Bars-counted_bars-1;
   while(i>=0)
     {
      price=(Kijun_Buffer[i]+Tenkan_Buffer[i])/2;
      SpanA_Buffer[i]=price;
      SpanA2_Buffer[i]=price;
      i--;
     }
//---- Senkou Span B
   i=Bars-Senkou;
   if(counted_bars>Senkou) i=Bars-counted_bars-1;
   while(i>=0)
     {
      high=High[i]; low=Low[i]; k=i-1+Senkou;
      while(k>=i)
        {
         price=High[k];
         if(high<price) high=price;
         price=Low[k];
         if(low>price) low=price;
         k--;
        }
      price=(high+low)/2;
      SpanB_Buffer[i]=price;
      SpanB2_Buffer[i]=price;
      i--;
     }
//---- Chinkou Span
   i=Bars-1;
   if(counted_bars>1) i=Bars-counted_bars-1;
   while(i>=0) { Chinkou_Buffer[i]=Close[i]; i--; }
//----

//---- Guide
//差の絶対値がこの値以下の時は2つの値の差は無いとみなす
   double ValueEqual_margin=ValueEqual_marginPoint*Point;

// ガイド表示のy座標(相対)
   int Guide_ydis=2;
   if(GuideText_corner==0) Guide_ydis+=10;

// 基準線の傾き
   int Kijun_Trend=getPointTrend(Kijun_Buffer,0,ValueEqual_margin);
   string Kijun_Trend_text;
   switch(Kijun_Trend) 
     {
      case  1: Kijun_Trend_text="基準線の傾き：上"; break;
      case  0: Kijun_Trend_text="基準線の傾き：横"; break;
      case -1: Kijun_Trend_text="基準線の傾き：下"; break;
     }
   createGuideLabel("Kijun-Trend",GuideText_corner,2,Guide_ydis,Kijun_Trend_text,8,"MS UI Gothic",GuideText_color);
   Guide_ydis+=10;

// 価格と基準線の比較
// Closeが渡せなかったのでChinkou_Bufferで代用
   int Price_Kijun=compareArray(Chinkou_Buffer,Kijun_Buffer,0,0,ValueEqual_margin);
   string Price_Kijun_text;
   switch(Price_Kijun) 
     {
      case  2: Price_Kijun_text="価格が基準線より：上"; break;
      case  1: Price_Kijun_text="価格が基準線を上抜け"; break;
      case  0: Price_Kijun_text="価格と基準線が同値";   break;
      case -1: Price_Kijun_text="価格が基準線を下抜け"; break;
      case -2: Price_Kijun_text="価格が基準線より：下"; break;
     }
   createGuideLabel("Price-Kijun",GuideText_corner,2,Guide_ydis,Price_Kijun_text,8,"MS UI Gothic",GuideText_color);
   Guide_ydis+=10;

// 価格と転換線の比較
// Closeが渡せなかったのでChinkou_Bufferで代用
   int Price_Tenkan=compareArray(Chinkou_Buffer,Tenkan_Buffer,0,0,ValueEqual_margin);
   string Price_Tenkan_text;
   switch(Price_Tenkan) 
     {
      case  2: Price_Tenkan_text="価格が転換線より：上"; break;
      case  1: Price_Tenkan_text="価格が転換線を上抜け"; break;
      case  0: Price_Tenkan_text="価格と転換線が同値";   break;
      case -1: Price_Tenkan_text="価格が転換線を下抜け"; break;
      case -2: Price_Tenkan_text="価格が転換線より：下"; break;
     }
   createGuideLabel("Price-Tenkan",GuideText_corner,2,Guide_ydis,Price_Tenkan_text,8,"MS UI Gothic",GuideText_color);
   Guide_ydis+=10;

// 転換線と基準線の比較
   int Tenkan_Kijun=compareArray(Tenkan_Buffer,Kijun_Buffer,0,0,ValueEqual_margin);
   string Tenkan_Kijun_text;
   switch(Tenkan_Kijun) 
     {
      case  2: Tenkan_Kijun_text="転換線が基準線より：上"; break;
      case  1: Tenkan_Kijun_text="転換線が基準線を上抜け"; break;
      case  0: Tenkan_Kijun_text="転換線と基準線が同値";   break;
      case -1: Tenkan_Kijun_text="転換線が基準線を下抜け"; break;
      case -2: Tenkan_Kijun_text="転換線が基準線より：下"; break;
     }
   createGuideLabel("Tenkan-Kijun",GuideText_corner,2,Guide_ydis,Tenkan_Kijun_text,8,"MS UI Gothic",GuideText_color);
   Guide_ydis+=10;

// 遅行スパンと価格の比較
// Closeが渡せなかったのでChinkou_Bufferで代用
   int ChinkouSpan_Price=compareArray(Chinkou_Buffer,Chinkou_Buffer,0,Kijun-1,ValueEqual_margin);
   string ChinkouSpan_Price_text;
   switch(ChinkouSpan_Price) 
     {
      case  2: ChinkouSpan_Price_text="遅行スパンが価格より：上"; break;
      case  1: ChinkouSpan_Price_text="遅行スパンが価格を上抜け"; break;
      case  0: ChinkouSpan_Price_text="遅行スパンと価格が同値";   break;
      case -1: ChinkouSpan_Price_text="遅行スパンが価格を下抜け"; break;
      case -2: ChinkouSpan_Price_text="遅行スパンが価格より：下"; break;
     }
   createGuideLabel("ChinkouSpan-Price",GuideText_corner,2,Guide_ydis,ChinkouSpan_Price_text,8,"MS UI Gothic",GuideText_color);
   Guide_ydis+=10;

// 価格と雲の比較
// Closeが渡せなかったのでChinkou_Bufferで代用
   int Price_SpanA = compareArray(Chinkou_Buffer, SpanA_Buffer, 0, Kijun-1, ValueEqual_margin);
   int Price_SpanB = compareArray(Chinkou_Buffer, SpanB_Buffer, 0, Kijun-1, ValueEqual_margin);
   int SpanA_SpanB = compareArray(SpanA_Buffer, SpanB_Buffer, Kijun-1, Kijun-1, ValueEqual_margin);
   int Price_Kumo;
   string Price_Kumo_text="Price_SpanA="+Price_SpanA+", Price_SpanB="+Price_SpanB+", SpanA_SpanB="+SpanA_SpanB+"";
   string debug_text=Price_Kumo_text;

   if(SpanA_SpanB>=0) 
     {
      switch(Price_SpanA) 
        {
         case  2: Price_Kumo_text="価格が雲より：上"; Price_Kumo = 2; break;
         case  1: Price_Kumo_text="価格が雲を上抜け"; Price_Kumo = 1; break;
         case  0: Price_Kumo_text="価格が雲の上限"; Price_Kumo = 0; break;
        }
      switch(Price_SpanB) 
        {
         case   0: Price_Kumo_text="価格が雲の下限"; Price_Kumo = 0; break;
         case  -1: Price_Kumo_text="価格が雲を下抜け"; Price_Kumo = -1; break;
         case  -2: Price_Kumo_text="価格が雲より：下"; Price_Kumo = -2; break;
        }
      if((Price_SpanA==-1 && Price_SpanB>0) || (Price_SpanB==1 && Price_SpanA<0)) 
        {
         Price_Kumo_text="価格が雲に突入"; Price_Kumo=0;
        }
      if(Price_SpanA==-2 && Price_SpanB==2) 
        {
         Price_Kumo_text="価格が雲の中"; Price_Kumo=0;
        }
     }
   if(SpanA_SpanB<0) 
     {
      switch(Price_SpanB) 
        {
         case  2: Price_Kumo_text="価格が雲より：上"; Price_Kumo = 2; break;
         case  1: Price_Kumo_text="価格が雲を上抜け"; Price_Kumo = 1; break;
         case  0: Price_Kumo_text="価格が雲の上限"; Price_Kumo = 0; break;
        }
      switch(Price_SpanA) 
        {
         case   0: Price_Kumo_text="価格が雲の下限"; Price_Kumo = 0; break;
         case  -1: Price_Kumo_text="価格が雲を下抜け"; Price_Kumo = -1; break;
         case  -2: Price_Kumo_text="価格が雲より：下"; Price_Kumo = -2; break;
        }
      if((Price_SpanB==-1 && Price_SpanA>0) || (Price_SpanA==1 && Price_SpanB<0)) 
        {
         Price_Kumo_text="価格が雲に突入"; Price_Kumo=0;
        }
      if(Price_SpanB==-2 && Price_SpanA==2) 
        {
         Price_Kumo_text="価格が雲の中"; Price_Kumo=0;
        }
     }
   createGuideLabel("Price-Kumo",GuideText_corner,2,Guide_ydis,Price_Kumo_text,8,"MS UI Gothic",GuideText_color);
   Guide_ydis+=10;
   if(MathAbs(SpanA_SpanB)<2) 
     {
      createGuideLabel("SpanA-SpanB",GuideText_corner,2,Guide_ydis,"先行スパン1と2がクロス",8,"MS UI Gothic",GuideText_color);
      Guide_ydis+=10;
        } else {
      createGuideLabel("SpanA-SpanB",GuideText_corner,2,Guide_ydis," ",8,"MS UI Gothic",GuideText_color);
     }

// 三役好転/三役逆転
   if(Tenkan_Kijun>0 && Price_Kumo>0 && ChinkouSpan_Price>0) 
     {
      createGuideLabel("Sannyaku",GuideText_corner,2,Guide_ydis,"三役好転ｷﾀ━━━(ﾟ∀ﾟ)━━━!!!",8,"MS UI Gothic",GuideText_color);
      Guide_ydis+=10;
        } else if(Tenkan_Kijun<0 && Price_Kumo<0 && ChinkouSpan_Price<0) {
      createGuideLabel("Sannyaku",GuideText_corner,2,Guide_ydis,"三役逆転ｷﾀ━━━(ﾟДﾟ)━━━!!!",8,"MS UI Gothic",GuideText_color);
      Guide_ydis+=10;
        } else {
      createGuideLabel("Sannyaku",GuideText_corner,2,Guide_ydis," ",8,"MS UI Gothic",GuideText_color);
     }

//----
   return(0);
  }
// subroutine
int createGuideLabel(string subname,int corner,int xdistance,int ydistance,string text,int fontsize,string font,color textcolor)
  {
   string objectname=obj_prefix+subname;
   ObjectCreate(objectname,OBJ_LABEL,0,0,0);
   ObjectSet(objectname,OBJPROP_CORNER,corner);
   ObjectSet(objectname,OBJPROP_XDISTANCE,xdistance);
   ObjectSet(objectname,OBJPROP_YDISTANCE,ydistance);
   ObjectSetText(objectname,text+"　　　　　　 　",fontsize,font,textcolor);
   return(0);
  }
// return 1(up trend), -1(down trend), 0(flat)
int getPointTrend(double &array[],int shift,double margin)
  {
   if(array[shift]-array[shift+1]>margin && array[shift]-array[shift+2]>margin) 
     {
      return(1);
        } else if(array[shift+1]-array[shift]>margin && array[shift+2]-array[shift]>margin) {
      return(-1);
        } else {
      return(0);
     }
  }
// return 2(the source is up to the target), 1( the source crosses over the target),
// 0(difference is under the margin),
// -1(the source crosses under the target), -2(the source is under to the target)
int compareArray(double &sourceArray[],double &targetArray[],int source_shift,int target_shift,double margin)
  {
   int retval;
   if(sourceArray[source_shift]-targetArray[target_shift]>margin) 
     {
      retval=2;
      for(int i=0; i<=TurningPoint_margin; i++) 
        {
         if(targetArray[target_shift+i+1]-sourceArray[source_shift+i+1]>=margin
            && targetArray[target_shift+i+2]-sourceArray[source_shift+i+2]>margin) 
           {
            retval=1; i=TurningPoint_margin;
           }
        }
        } else if(targetArray[target_shift]-sourceArray[source_shift]>margin) {
      retval=-2;
      for(i=0; i<=TurningPoint_margin; i++) 
        {
         if(sourceArray[source_shift+i+1]-targetArray[target_shift+i+1]>=margin
            && sourceArray[source_shift+i+2]-targetArray[target_shift+i+2]>margin) 
           {
            retval=-1; i=TurningPoint_margin;
           }
        }
        } else {
      retval=0;
     }
   return(retval);
  }

//+------------------------------------------------------------------+
