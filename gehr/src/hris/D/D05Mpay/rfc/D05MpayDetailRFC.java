package	hris.D.D05Mpay.rfc;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;
import com.sns.jdf.util.DateTime;

import hris.D.D05Mpay.D05MpayDetailData4;
import hris.D.D05Mpay.D05MpayDetailData5;

/**
 * D05MpayDetailRFC.java
 * 개인의 월급여 내역 정보를 가져오는 RFC를 호출하는 Class
 *
 * @author 최영호
 * @version 1.0, 2002/01/28
 *   Update       : 2013-06-24 [CSR ID:2353407] sap에 추가암검진 추가 건  
 *   				  : 2016-08-31 통합GEHR
 */
public class D05MpayDetailRFC extends SAPWrap {

    private String functionName = "ZGHR_GET_PAY_INFO"; //ZHRP_GET_PAY_INFO

    /**
     * 개인의 월급여 내역 정보를 가져오는 RFC를 호출하는 Method
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    public Vector getMpayDetail( String empNo, String year, String ocrsn, String flag,  String seqnr  ,String  webUserId) throws GeneralException {  // 5월 21일 순번 추가 
    
        JCO.Client mConnection = null;
        
        try{
            mConnection = getClient();
            Logger.debug.println(this,"Step11 createFunction");
            JCO.Function function = createFunction(functionName) ;
            Logger.debug.println(this,"Step11 setInput");
            setInput(function, empNo, year, ocrsn, flag, seqnr,webUserId);  // 5월 21일 순번 추가
            Logger.debug.println(this,"Step11 excute");
            excute(mConnection, function);
            Vector sum = new Vector();
            Vector ret = null;
            
            ret = getTable(hris.D.D05Mpay.D05MpayDetailData1.class, function, "T_OVSLST"); // 해외급여 반영내역(항목) 내역
            sum.addElement(ret);	//inx:0
            
            ret = getTable(hris.D.D05Mpay.D05MpayDetailData2.class, function, "T_PAYLST"); // 지급내역/공제내역
            sum.addElement(ret);   //inx:1
            
            ret = getTable(hris.D.D05Mpay.D05MpayDetailData3.class, function, "T_TAXLST"); // 과세추가내역
            sum.addElement(ret); // inx:2
            
//            if( gubun == "1" ) {        
/*              
              for ( int i = 0 ; i < ret.size() ; i++ ) {
                D05MpayDetailData1 data1 = (D05MpayDetailData1)ret.get(i);
                
                if(data1.BET01.equals("")){ data1.BET01=""; }else{data1.BET01 = Double.toString( Double.parseDouble(data1.BET01) * 100.0 );}
                if(data1.BET02.equals("")){ data1.BET02=""; }else{data1.BET02 = Double.toString( Double.parseDouble(data1.BET02) * 100.0 );}
                if(data1.BET03.equals("")){ data1.BET03=""; }else{data1.BET03 = Double.toString( Double.parseDouble(data1.BET03) * 100.0 );}
              }
*/ //          } else if( gubun == "2" ) {  
/*            
              for ( int i = 0 ; i < ret.size() ; i++ ) {
                D05MpayDetailData2 data2 = (D05MpayDetailData2)ret.get(i);
                
                if(data2.BET01.equals("")){ data2.BET01=""; }else{data2.BET01 = Double.toString( Double.parseDouble(data2.BET01) * 100.0 );}
                if(data2.BET02.equals("")){ data2.BET02=""; }else{data2.BET02 = Double.toString( Double.parseDouble(data2.BET02) * 100.0 );}
              }
*/ //          } else if( gubun == "3" ) {  
//            ret = new Vector();
/*             
              for ( int i = 0 ; i < 1 ; i++ ) {
              for ( int i = 0 ; i < ret.size(); i++ ) {
                D05MpayDetailData3 data3 = (D05MpayDetailData3)ret.get(i);
                D05MpayDetailData3 data3 = new D05MpayDetailData3();
                
                if(data3.BET01.equals("")){ data3.BET01=""; }else{data3.BET01 = Double.toString( Double.parseDouble(data3.BET01) * 100.0 );}
                if(data3.BET02.equals("")){ data3.BET02=""; }else{data3.BET02 = Double.toString( Double.parseDouble(data3.BET02) * 100.0 );}
                if(data3.BET03.equals("")){ data3.BET03=""; }else{data3.BET03 = Double.toString( Double.parseDouble(data3.BET03) * 100.0 );}
                

                data3.BET01 = "2000000";
                data3.BET02 = "3000000";
                data3.BET03 = "4000000";
                data3.LGTX1 = "밥값";
                data3.LGTX2 = "목욕비";
                data3.LGTX3 = "차비";
                
                ret.addElement(data3);

              }
*/ //         }

            /** 
             *  getPerson() 통합
             */
            Object retPerson = getStructor( new D05MpayDetailData4(), function, "S_PERSON_INFO");
            D05MpayDetailData4 data4 = (D05MpayDetailData4) retPerson;
             if(data4.DYBET.equals("")){ data4.DYBET=""; }else{data4.DYBET = Double.toString( Double.parseDouble(data4.DYBET) * 100.0 );}
             sum.addElement(retPerson); // Inx:3
             
             /**
              * getPaysum 부분
              */
             Object retPaySum = getStructor( new D05MpayDetailData5() , function, "S_PAYSUM_INFO"); // 지급내역/공제내역 합;
             sum.addElement(retPaySum); // inx:4
             
            return sum;
            
        } catch(Exception ex){
            Logger.sap.println(this, " SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }
 
    public Object getPerson(String empNo, String year, String ocrsn, String flag, String seqnr,String webUserId) throws GeneralException {  // 5월 21일 순번 추가

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, year, ocrsn, flag, seqnr,webUserId);  // 5월 21일 순번 추가
            excute(mConnection, function);
            Object ret = getStructor( new D05MpayDetailData4(), function, "S_PERSON_INFO");
                
            D05MpayDetailData4 data4 = (D05MpayDetailData4)ret;
            
             if(data4.DYBET.equals("")){ data4.DYBET=""; }else{data4.DYBET = Double.toString( Double.parseDouble(data4.DYBET) * 100.0 );}
/*                
               D05MpayDetailData4 data4 = (D05MpayDetailData4)ret;
               
                if(data4.BET01.equals("")){ data4.BET01=""; }else{data4.BET01 = Double.toString( Double.parseDouble(data4.BET01) * 100.0 );}
                if(data4.BET02.equals("")){ data4.BET02=""; }else{data4.BET02 = Double.toString( Double.parseDouble(data4.BET02) * 100.0 );}
                if(data4.BET03.equals("")){ data4.BET03=""; }else{data4.BET03 = Double.toString( Double.parseDouble(data4.BET03) * 100.0 );}
                if(data4.BET04.equals("")){ data4.BET04=""; }else{data4.BET04 = Double.toString( Double.parseDouble(data4.BET04) * 100.0 );}
                if(data4.BET05.equals("")){ data4.BET05=""; }else{data4.BET05 = Double.toString( Double.parseDouble(data4.BET05) * 100.0 );}
                if(data4.BET06.equals("")){ data4.BET06=""; }else{data4.BET06 = Double.toString( Double.parseDouble(data4.BET06) * 100.0 );}
                if(data4.BET07.equals("")){ data4.BET07=""; }else{data4.BET07 = Double.toString( Double.parseDouble(data4.BET07) * 100.0 );}
                if(data4.BET08.equals("")){ data4.BET08=""; }else{data4.BET08 = Double.toString( Double.parseDouble(data4.BET08) * 100.0 );}
                if(data4.BET09.equals("")){ data4.BET09=""; }else{data4.BET09 = Double.toString( Double.parseDouble(data4.BET09) * 100.0 );}
                if(data4.BET10.equals("")){ data4.BET10=""; }else{data4.BET10 = Double.toString( Double.parseDouble(data4.BET10) * 100.0 );}
                if(data4.BET11.equals("")){ data4.BET11=""; }else{data4.BET11 = Double.toString( Double.parseDouble(data4.BET11) * 100.0 );}
                if(data4.BET12.equals("")){ data4.BET12=""; }else{data4.BET12 = Double.toString( Double.parseDouble(data4.BET12) * 100.0 );}
                if(data4.BET13.equals("")){ data4.BET13=""; }else{data4.BET13 = Double.toString( Double.parseDouble(data4.BET13) * 100.0 );}
                if(data4.BET14.equals("")){ data4.BET14=""; }else{data4.BET14 = Double.toString( Double.parseDouble(data4.BET14) * 100.0 );}
*/         
             Logger.sap.println(this, "data4 : "+ret.toString());
            return ret;
            
        }catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }  
    

    public Object getPaysum(String empNo, String year, String ocrsn, String flag, String seqnr,String webUserId) throws GeneralException {  // 5월 21일 순번 추가

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo, year, ocrsn, flag, seqnr,webUserId);  // 5월 21일 순번 추가
            excute(mConnection, function);
            Object ret = getStructor( new D05MpayDetailData5() , function, "S_PAYSUM_INFO"); // 지급내역/공제내역 합;
/*  
               D05MpayDetailData5 data5 = (D05MpayDetailData5)ret;
  
                if(data5.BET01.equals("")){ data5.BET01=""; }else{data5.BET01 = Double.toString( Double.parseDouble(data5.BET01) * 100.0 );}
                if(data5.BET02.equals("")){ data5.BET02=""; }else{data5.BET02 = Double.toString( Double.parseDouble(data5.BET02) * 100.0 );}
*/            
             return ret;
        }catch(Exception ex){
            Logger.sap.println(this, "SAPException : "+ex.toString());
            throw new GeneralException(ex);
        } finally {
            close(mConnection);
        }
    }       
    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @param value java.lang.String 사번
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String value, String value1, String value2, String value3, String value4, String value5) throws GeneralException {  // 5월 21일 순번 추가
       
		DateTime ymd = null; 
        String value6 = ymd.getShortDateString();
        
        setField(function, "I_PERNR", value);
        setField(function, "I_DATE", value1);
        setField(function, "I_ZOCRSN", value2);
        setField(function, "I_FLAG", value3);
        setField(function, "I_SEQNR", value4);  // 5월 21일 순번 추가 
        setField(function, "I_ID", value5);  
        setField(function, "I_DATUM", value6);  
        
    }
            
    
}