//+ ------------------------------------------------------------------ +
//|                                              Madokasu_Fractals.mq4 |
//+ ------------------------------------------------------------------ +
#property link      "https://madokasu-fx.blogspot.com"

#property indicator_chart_window
//double Fr_Buffer[];
double Fr_UPPER,
         Fr_LOWER,
         High_Fr_LOWER,
         High_Fr_LOWER_2;
double High_Win,
         Low_Win,
         shift_X,
         shift_Y;
int per,
      T_Fr_LOWER,
      T_Fr_UPPER,
      Low_Fr_UPPER,
      Low_Fr_UPPER_2,
      Level_new;
string text,PERIOD;

extern color COLOR_UP = Yellow;
extern color COLOR_DN = Magenta;

//+ ------------------------------------------------------------------ +
//| Custom indicator initialization function                         |
// + ------------------------------------------------------------------ +
int init()
  {
   del();
   //Find the minimum allowable TakeProft and StopLoss
   Level_new = MarketInfo(Symbol(),MODE_STOPLEVEL);

   per = Period();
   PERIOD = string_per(per);
   Comment("FRACTALS    " + PERIOD + "    " + time(CurTime()));
   return(0);
  }
// + ------------------------------------------------------------------ +

// + ------------------------------------------------------------------ +
//| Custom indicator deinitialization function                       |
// + ------------------------------------------------------------------ +
int start()
  {
   Fr_UPPER = 0;
   Fr_LOWER = 100000;
   High_Win = WindowPriceMax();
   Low_Win = WindowPriceMin();
   shift_X = WindowBarsPerChart()/80*per;
   shift_Y = (High_Win-Low_Win) / 50;
   int s = 0;
   for(int n = WindowBarsPerChart(); n>=0; n--)
      Fractal(n);

   return(0);
  }

int Fractal(int br)
  {
   double Fr_Up = iFractals(NULL, 0, MODE_UPPER, br + 3);
   double Fr_Dn = iFractals(NULL, 0, MODE_LOWER, br + 3);
   if(Fr_Dn==0 && Fr_Up==0) return(0);
   string sTime= time(Time[br + 3]) + " " + PERIOD;
   int strength=0,lever_arm=0,i;
//----------------------------------- bottom fractal ------
   if(Fr_Dn!=0 && Fr_LOWER>Fr_Dn)
     {
      Fr_LOWER = Fr_Dn;
      High_Fr_LOWER = High[br + 3];
      High_Fr_LOWER_2 = High[br + 2];
      T_Fr_LOWER = Time[br + 3];
      if(Fr_UPPER>0 && (Fr_UPPER - Open[br])>(Open[br] - Fr_LOWER))//fracture formation
        {
         ObjectCreate("Fr " + sTime + " LOWER ", OBJ_ARROW, 0, Time[br + 3], Fr_Dn-shift_Y*2, 0, 0, 0, 0);
         ObjectSet("Fr " + sTime + " LOWER ", OBJPROP_ARROWCODE, 218);
         ObjectSet("Fr " + sTime + " LOWER ", OBJPROP_COLOR,COLOR_DN);
         ObjectCreate("Fr sl " + sTime + " start_LOWER", OBJ_TREND, 0, T_Fr_UPPER, Fr_UPPER, T_Fr_LOWER, Fr_LOWER);
         ObjectSet("Fr sl " + sTime + " start_LOWER", OBJPROP_COLOR, COLOR_DN);    // COLOUR
         ObjectSet("Fr sl " + sTime + " start_LOWER", OBJPROP_STYLE, STYLE_DOT);// Style
         ObjectSet("Fr sl " + sTime + " start_LOWER", OBJPROP_BACK, true);
         ObjectSet("Fr sl " + sTime + " start_LOWER", OBJPROP_RAY, false);     // Ray
         strength=0;
         for(i=1; i<=5; i++ ) {
            color_bar(per,br + i,Fr_Dn-shift_Y);
            if(Candle_color(per,br + i)==1 || Candle_color(per,br + i)==4)
               strength++ ;
         }
         lever_arm=(Fr_UPPER-Fr_LOWER)/Point/Level_new;
         text =  "Fr " + sTime + " LOWER strength"
               + "  р " + DoubleToStr(lever_arm,0)
               + "-" + DoubleToStr((Open[br]-Fr_LOWER)/Point/Level_new,0)
               + " bar " + DoubleToStr((T_Fr_LOWER-T_Fr_UPPER)/per/60,0)
               + " MACD " + DoubleToStr(iMACD(NULL,per,5,34,5,PRICE_CLOSE,MODE_MAIN  ,br + 3), Digits)
               +  " с " + DoubleToStr(strength,0) + " " + string_per(per);
         ObjectDelete(text);
         ObjectCreate(text,OBJ_TEXT,0,Time[br + 3],Fr_Dn-shift_Y*3.2,0,0,0,0);
         ObjectSetText(text,
            DoubleToStr(iMACD(NULL,per, 5, 34, 5, PRICE_CLOSE, MODE_MAIN, br + 3), Digits) + " "
            + DoubleToStr(iMFI(NULL, per, 15, br + 3), 0), 8, "Arial");
         ObjectSet(text,OBJPROP_COLOR,COLOR_DN);
         Fr_UPPER = 0;
         T_Fr_UPPER = 0;
         Low_Fr_UPPER = 0;
         Low_Fr_UPPER_2 = 0;
         return(1);
        }
     }
//----------------------------------- upper fractal ------------
   if(Fr_Up!=0 && Fr_UPPER<Fr_Up)
     {
      Fr_UPPER=Fr_Up;
      Low_Fr_UPPER=Low[br + 3];
      Low_Fr_UPPER_2=Low[br + 2];
      T_Fr_UPPER=Time[br + 3];
      if(Fr_LOWER<100000 && (Fr_UPPER-Open[br])<(Open[br]-Fr_LOWER))//fracture formation
        {
         ObjectCreate("Fr " + sTime + " UPPER", OBJ_ARROW, 0, Time[br + 3], Fr_Up + shift_Y*2, 0, 0, 0, 0);
         ObjectSet("Fr " + sTime + " UPPER", OBJPROP_ARROWCODE, 217);
         ObjectSet("Fr " + sTime + " UPPER", OBJPROP_COLOR, COLOR_UP);
         ObjectCreate("Fr su " + sTime + " start_UPPER", OBJ_TREND, 0, T_Fr_LOWER, Fr_LOWER, T_Fr_UPPER, Fr_UPPER);
         ObjectSet("Fr su " + sTime + " start_UPPER", OBJPROP_COLOR, COLOR_UP);    // COLOUR
         ObjectSet("Fr su " + sTime + " start_UPPER", OBJPROP_STYLE, STYLE_SOLID);// Style
         ObjectSet("Fr su " + sTime + " start_UPPER", OBJPROP_BACK, true);
         ObjectSet("Fr su " + sTime + " start_UPPER", OBJPROP_RAY, false);     // Ray
         strength = 0;
         for(i=1; i<=5; i++ ) {
            color_bar(per,br + i,Fr_Up + shift_Y);
            if(Candle_color(per,br + i)==1 || Candle_color(per,br + i)==4)
               strength++ ;
            }
         lever_arm=(Fr_UPPER-Fr_LOWER)/Point/Level_new;
         text="Fr " + sTime + " UPPERstrength"
            + "  р " + DoubleToStr(lever_arm,0)
            + "-" + DoubleToStr((Fr_UPPER-Open[br])/Point/Level_new,0)
            + " bar " + DoubleToStr((T_Fr_UPPER-T_Fr_LOWER)/per/60,0)
            + " MACD " + " с " + DoubleToStr(strength,0) + " " + string_per(per);
         ObjectDelete(text);
         ObjectCreate(text,OBJ_TEXT,0,Time[br + 3],Fr_Up + shift_Y*3.0,0,0,0,0);
         ObjectSetText(text,
            DoubleToStr(iMACD(NULL, per, 5, 34, 5, PRICE_CLOSE, MODE_MAIN, br + 3), Digits) + " "
            + DoubleToStr(iMFI(NULL, per, 15, br + 3), 0), 8, "Arial");
         ObjectSet(text, OBJPROP_COLOR, COLOR_UP);
         Fr_LOWER = 100000;
         T_Fr_LOWER = 0;
         High_Fr_LOWER = 0;
         High_Fr_LOWER_2 = 0;
         return(-1);
        }
     }
//----------------------------
   return(0);
  }

int deinit()
  {
   del();
   return(0);
  }

int del()
  {
   for(int n=ObjectsTotal()-1; n>=0; n--)
     {
      string Obj_Name=ObjectName(n);
      if(StringFind(Obj_Name,"Fr",0)!=-1)
        {
         ObjectDelete(Obj_Name);
        }
     }
   return(0);
  }

string time(int taim)
  {
   string sTaim;
//int YY=TimeYear(taim);   // Year
   int MN=TimeMonth(taim);  // Month
   int DD=TimeDay(taim);    // Day
   int HH=TimeHour(taim);   // Hour
   int MM=TimeMinute(taim); // Minute

   if(DD<10)
      sTaim = "0" + DoubleToStr(DD,0);
   else
      sTaim = DoubleToStr(DD,0);
   sTaim = sTaim + "/";
   if(MN<10)
      sTaim = sTaim + "0" + DoubleToStr(MN,0);
   else
      sTaim = sTaim + DoubleToStr(MN,0);
   sTaim = sTaim + " ";
   if(HH<10)
      sTaim = sTaim + "0" + DoubleToStr(HH,0);
   else
      sTaim = sTaim + DoubleToStr(HH,0);
   if(MM<10)
      sTaim = sTaim + ":0" + DoubleToStr(MM,0);
   else
      sTaim = sTaim + ":" + DoubleToStr(MM,0);
   return(sTaim);
  }

// coloring bars
void color_bar(int _per,int br,double Y)
  {
   int X=iTime(NULL,_per,br);
   string sTime=time(Time[br]);
   color COLOUR;
   switch(Candle_color(_per,br))//COLOUR candles MFI
     {
      case 1 ://Green
         COLOUR = Lime;
         break;
      case 2 ://Fading
         COLOUR = Sienna;
         break;
      case 3 ://False
         COLOUR = Blue;
         break;
      case 4 ://Crouching
         COLOUR = DeepPink;
         break;
      default:
         COLOUR = White;
     }
   ObjectDelete("Fr color_bar " + sTime);
   ObjectCreate("Fr color_bar " + sTime, OBJ_ARROW,0, X, Y, 0, 0, 0, 0);
   ObjectSet("Fr color_bar " + sTime, OBJPROP_ARROWCODE, 117);
   ObjectSet("Fr color_bar " + sTime, OBJPROP_COLOR, COLOUR);
   ObjectSet("Fr color_bar " + sTime, OBJPROP_WIDTH, 0);
   ObjectSet("Fr color_bar " + sTime, OBJPROP_BACK, true);
  }

int Candle_color(int _per,int br)
  {
   if( iVolume(NULL, _per, br) > iVolume(NULL, _per, br + 1)
      && iBWMFI(NULL, _per, br) > iBWMFI(NULL, _per, br + 1) )
         return(1); //Green
   if( iVolume(NULL, _per, br) < iVolume(NULL, _per, br + 1)
      && iBWMFI(NULL, _per, br) < iBWMFI(NULL, _per, br + 1) )
         return(2); //Fading
   if( iVolume(NULL, _per, br) < iVolume(NULL, _per, br + 1)
      && iBWMFI(NULL, _per, br) > iBWMFI(NULL, _per, br + 1) )
         return(3); //False
   if( iVolume(NULL, _per, br) > iVolume(NULL, _per, br + 1)
      && iBWMFI(NULL, _per, br) < iBWMFI(NULL, _per, br + 1) )
         return(4); //Crouching

   return(0);//mistake
  }

string string_per(int _per)
  {
   switch(_per)
     {
      case 1    : return("M_1");
      break;
      case 5    : return("M_5");
      break;
      case 15   : return("M15");
      break;
      case 30   : return("M30");
      break;
      case 60   : return("H 1");
      break;
      case 240  : return("H_4");
      break;
      case 1440 : return("D_1");
      break;
      case 10080: return("W_1");
      break;
      case 43200: return("MN1");
      break;
     }
   return("period error");
  }
