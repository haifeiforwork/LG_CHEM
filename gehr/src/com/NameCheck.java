//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com;

import java.io.InputStream;
import java.io.PrintWriter;
import java.net.MalformedURLException;
import java.net.NoRouteToHostException;
import java.net.Socket;
import java.net.URL;
import java.net.URLEncoder;
import java.text.DecimalFormat;

public class NameCheck {
  public int ErrCode = 0;
  private String ChkName = "";
  private String Jumin = "";
  private String SiteCode = "";
  private String EncJumin = "";
  private int TimeOut = 0;
  final short PROC_OK = 0;
  final short DATA_ERR = 21;

  public NameCheck() {
  }

  public String getEnc() {
    return this.EncJumin;
  }

  public void setChkName(String var1) {
    this.ChkName = var1;
  }

  public String setJumin(String var1) {
    this.Jumin = var1.trim();
    return String.valueOf(this.getEncJumin(this.Jumin, 21));
  }

  public void setSiteCode(String var1) {
    this.SiteCode = var1;
  }

  public void setTimeOut(int var1) {
    this.TimeOut = var1;
  }

  public String getRtn() {
    return this.getNameCheck();
  }

  private int getRandom() {
    return Math.abs((new Long(System.currentTimeMillis())).intValue());
  }

  private String getNameCheck() {
    String var1 = "";
    Socket var2 = null;
    InputStream var3 = null;
    PrintWriter var4 = null;

    try {
      int var5 = this.getRandom();
      String var6 = "http://203.234.219.72/cnm.asp";//81~85 포트 오픈 필요
      URL var7 = new URL(var6);
      String var8 = var7.getHost();
      int var9 = 81 + var5 % 5;
      String var10 = var7.getFile();
      var2 = new Socket(var8, var9);
      var2.setSoTimeout(this.TimeOut);
      var4 = new PrintWriter(var2.getOutputStream(), false);
      var3 = var2.getInputStream();
      StringBuffer var11 = new StringBuffer();
      var11.append(URLEncoder.encode("a3", "euc-kr") + "=" + URLEncoder.encode(this.ChkName, "euc-kr") + "&");
      var11.append(URLEncoder.encode("a2", "euc-kr") + "=" + URLEncoder.encode(this.EncJumin, "euc-kr") + "&");
      var11.append(URLEncoder.encode("a1", "euc-kr") + "=" + URLEncoder.encode(this.SiteCode, "euc-kr"));
      int var12 = var11.toString().length();
      StringBuffer var13 = new StringBuffer();
      var13.append("POST " + var10 + " HTTP/1.1\n");
      var13.append("Accept: */*\n");
      var13.append("Connection: close\n");
      var13.append("Host: wtname.creditbank.co.kr\n");
      var13.append("Content-Type: application/x-www-form-urlencoded\n");
      var13.append("Content-Length: " + var12 + "\r\n");
      var13.append("\r\n");
      var13.append(var11.toString());
      var4.print(var13.toString());
      var4.flush();
      var13.setLength(0);
      String var14 = "";
      int var15 = 0;

      for(boolean var16 = true; var16 && var15 != -1; var16 = (var15 = var3.read()) == 114?((var15 = var3.read()) == 101?((var15 = var3.read()) == 115?((var15 = var3.read()) == 117?((var15 = var3.read()) == 108?((var15 = var3.read()) == 116?(var15 = var3.read()) != 61:true):true):true):true):true):true) {
        ;
      }

      byte[] var17 = new byte[2];
      var3.read(var17);
      var4.close();
      var3.close();
      var2.close();
      var2 = null;
      var3 = null;
      var4 = null;
      var1 = (new String(var17, "KSC5601")).toString();
    } catch (MalformedURLException var61) {
      if(var4 != null) {
        try {
          var4.close();
          var4 = null;
        } catch (Exception var60) {
          ;
        }
      }

      if(var3 != null) {
        try {
          var3.close();
          var3 = null;
        } catch (Exception var59) {
          ;
        }
      }

      if(var2 != null) {
        try {
          var2.close();
          var2 = null;
        } catch (Exception var58) {
          ;
        }
      }

      var1 = "62";
    } catch (NoRouteToHostException var62) {
      if(var4 != null) {
        try {
          var4.close();
          var4 = null;
        } catch (Exception var57) {
          ;
        }
      }

      if(var3 != null) {
        try {
          var3.close();
          var3 = null;
        } catch (Exception var56) {
          ;
        }
      }

      if(var2 != null) {
        try {
          var2.close();
          var2 = null;
        } catch (Exception var55) {
          ;
        }
      }

      var1 = "61";
    } catch (Exception var63) {
      if(var4 != null) {
        try {
          var4.close();
          var4 = null;
        } catch (Exception var54) {
          ;
        }
      }

      if(var3 != null) {
        try {
          var3.close();
          var3 = null;
        } catch (Exception var53) {
          ;
        }
      }

      if(var2 != null) {
        try {
          var2.close();
          var2 = null;
        } catch (Exception var52) {
          ;
        }
      }

      var1 = "63";
    } finally {
      if(var4 != null) {
        try {
          var4.close();
          var4 = null;
        } catch (Exception var51) {
          ;
        }
      }

      if(var3 != null) {
        try {
          var3.close();
          var3 = null;
        } catch (Exception var50) {
          ;
        }
      }

      if(var2 != null) {
        try {
          var2.close();
          var2 = null;
        } catch (Exception var49) {
          ;
        }
      }

    }

    return var1;
  }

  private int getEncJumin(String var1, int var2) {
    String var3 = "13814175622071120141181061768611993108841416921423107181672510714175411266712670119411737212225184002090820525212741182820947153241426022005196831631213938161862274312787181662007815703134602165910388182131264812368213511080911151159881253313998114131777122809215401592122930118692301418370102821668712210148061538513870120181727420355200961795413534192821169714960142231124510693129551063218404145651690617787165521359419983207241159515423148221137115237203671177021155195251257514999190251531020044";
    boolean var4 = false;
    boolean var5 = false;
    boolean var6 = false;
    boolean var7 = false;
    boolean var8 = false;
    String var9 = "";
    String var10 = "";
    String var11 = var1;
    String var12 = "00";
    String var13 = "";
    String var14 = "";
    String var15 = "";
    var1.trim();
    if(var2 != var1.length()) {
      return 21;
    } else {
      int var17 = var2 - var2 / 3 * 3;
      if(var17 == 2) {
        var11 = var1 + "00";
      } else if(var17 == 1) {
        var11 = var1 + "0";
      }

      int var18 = (int)(Math.random() * 100.0D);
      var15 = var3.substring(var18 * 5, var18 * 5 + 5);
      int var19 = Integer.valueOf(var15).intValue();
      int var20 = var11.length() / 3 / 2;
      DecimalFormat var16 = null;
      var16 = new DecimalFormat("00");
      var13 = var16.format((long)var18);
      var16 = new DecimalFormat("00000");

      int var21;
      for(var21 = 0; var21 < var20; ++var21) {
        var14 = var11.substring(var21 * 2 * 3, var21 * 2 * 3 + 3);
        var9 = var16.format((long)((new Integer(var14)).intValue() + var19));
        var14 = var11.substring((var21 * 2 + 1) * 3, (var21 * 2 + 1) * 3 + 3);
        var10 = var16.format((long)((new Integer(var14)).intValue() + var19));
        var13 = var13 + var10;
        var13 = var13 + var9;
      }

      if(var20 * 2 < var11.length() / 3) {
        var14 = var11.substring(var21 * 2 * 3, var21 * 2 * 3 + 3);
        var9 = var16.format((long)((new Integer(var14)).intValue() + var19));
        var13 = var13 + var9;
      }

      this.EncJumin = var13;
      return 0;
    }
  }
}
