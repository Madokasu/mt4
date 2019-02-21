//+------------------------------------------------------------------+
//|                                         Madokasu_Put_Numbers.mq4 |
//+------------------------------------------------------------------+
#property link        "https://madokasu-fx.blogspot.com"

#property strict
#property indicator_chart_window
#property indicator_buffers 1

#property indicator_color1 clrLawnGreen

#property indicator_width1 2

input color UpColor = clrAqua;      //色
input color labelColor = clrSilver; //色

input int maxlimit = 300;           //最大表示本数

double sanpeiUp[];

string sName = "SG";

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit(){

   IndicatorBuffers(1);
   SetIndexBuffer(0, sanpeiUp);

   SetIndexStyle(0, DRAW_ARROW, STYLE_SOLID);

   SetIndexArrow(0, SYMBOL_ARROWUP);
   
   objDelete(sName);
   
   return(INIT_SUCCEEDED);
}


//+------------------------------------------------------------------+ 
//| Expert deinitialization function                                 | 
//+------------------------------------------------------------------+ 
void OnDeinit(const int reason){
   objDelete(sName);
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[]){

   int limit = rates_total - prev_calculated;
   
   if(limit != 0){
      limit = MathMin(maxlimit, rates_total-5);
      objDelete(sName);
   }
   
   for(int i=limit; i>=1; i --){
     sanpeiUp[i] = EMPTY_VALUE;
     TextCreate(sName+"_speUp_"+IntegerToString(i), time[i], low[i], IntegerToString(i), labelColor, "@Gothic", 270, ANCHOR_LEFT);
   }
   
   return(rates_total);
}


//+------------------------------------------------------------------+ 
//| Creating Text object                                             | 
//+------------------------------------------------------------------+ 
bool TextCreate(const string            name="Text",              // object name 
                datetime                time=0,                   // anchor point time 
                double                  price=0,                  // anchor point price 
                const string            text="Text",              // the text itself 
                const color             clr=clrRed,
                const string            font="Gothic",
                const int               angle=0,
                const int               anchor=ANCHOR_LEFT){ 

   ResetLastError(); 

   if(!ObjectCreate(0, name, OBJ_TEXT, 0, time, price)){ 
      Print(__FUNCTION__, ": failed to create \"Text\" object! Error code = ",GetLastError()); 
      return(false); 
   }
    
   ObjectSetString(0, name, OBJPROP_TEXT, text); 
   ObjectSetString(0, name, OBJPROP_FONT, font); 
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 8); 
   ObjectSetDouble(0, name, OBJPROP_ANGLE, angle); 
   ObjectSetInteger(0, name, OBJPROP_ANCHOR, anchor); 
   ObjectSetInteger(0, name, OBJPROP_COLOR, clr); 
   ObjectSetInteger(0, name, OBJPROP_BACK, true); 
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false); 
   ObjectSetInteger(0, name, OBJPROP_SELECTED, false); 
   ObjectSetInteger(0, name, OBJPROP_HIDDEN, true); 
   ObjectSetInteger(0, name, OBJPROP_ZORDER, 0); 

   return(true); 
}

void objDelete(string basicName){

   for(int i=ObjectsTotal();i>=0;i--){
      string ObjName = ObjectName(i);
      if(StringFind(ObjName, basicName) >=0) ObjectDelete(ObjName);
   }
}
