package hris.D.rfc ;

import java.util.Vector;

import com.sap.mw.jco.JCO;
import com.sns.jdf.GeneralException;
import com.sns.jdf.Logger;
import com.sns.jdf.sap.SAPWrap;

import hris.D.D01OT.D01OTData;

/**
 * D02KongsuHourRFC.java
 * 근태 공수를을 가져오는 RFC를 호출하는 Class
 *
 * @author 한성덕
 * @version 1.0, 2012/06/14
 *                2.0 2015/06/18 [CSR ID:2803878] 초과근무 신청 Process 변경 요청
 *                2016/04/29 [CSR ID:3043406] 급여명세표 내 공수 현황 기준 변경 요청
 */
public class D02KongsuHourRFC  extends SAPWrap {

    private String functionName = "ZGHR_RFC_CALC_KONGSU_HOUR" ;

    /**
     * 근태 내용을 가져오는 RFC를 호출하는 Method
     *  @param     java.lang.String 사원번호
     *  @return    java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
    public String getHour( String empNo, String YYYYMM ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, empNo, YYYYMM) ;
            excute( mConnection, function ) ;

            String ret = getOutput( function ) ;

            return ret ;
        } catch( Exception ex ) {
            Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
            throw new GeneralException( ex ) ;
        } finally {
            close( mConnection ) ;
        }
    }


    /**
     * 근태 내용을 가져오는 RFC를 호출하는 Method
     *  @param     java.lang.String 사원번호
     *  @return    java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     *  [CSR ID:3043406] 급여명세표 내 공수 현황 기준 변경 요청
     */
    public Vector getHour2( String empNo, String YYYYMM ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, empNo, YYYYMM) ;
            excute( mConnection, function ) ;

            Vector ret = getOutput4( function ) ;

            return ret ;
        } catch( Exception ex ) {
            Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
            throw new GeneralException( ex ) ;
        } finally {
            close( mConnection ) ;
        }
    }
    /**
     * 초과근무 내용을 가져오는 RFC를 호출하는 Method(초과근무 현황 조회)
     *  @param     java.lang.String 사원번호
     *  @return    java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
    public Vector getOvtmHour( String empNo, String YYYYMM, String iFlag ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, empNo, YYYYMM, iFlag) ;
            excute( mConnection, function ) ;

            Vector ret = getOutput1( function ) ;

            return ret ;
        } catch( Exception ex ) {
            Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
            throw new GeneralException( ex ) ;
        } finally {
            close( mConnection ) ;
        }
    }


    /** [WorkTime52]
     * 초과근무 내용을 가져오는 RFC를 호출하는 Method(초과근무 현황 조회)
     *  @param     java.lang.String 사원번호
     *  @return    java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
    public Vector getOvtmHour2( String empNo, String I_DATE, String iFlag , String I_NTM ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput2( function, empNo, I_DATE, iFlag, I_NTM) ;
            excute( mConnection, function ) ;

            Vector ret = getOutput1( function ) ;

            return ret ;
        } catch( Exception ex ) {
            Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
            throw new GeneralException( ex ) ;
        } finally {
            close( mConnection ) ;
        }
    }





    /**
     * 초과근무 내용을 가져오는 RFC를 호출하는 Method(신청 시 호출)
     *  @param   java.lang.String 사원번호
     *  @param  	java.lang.String iFlag  : 'C' = 현황, 'R' = 신청,'M' = 수정, 'G' = 결재
     *  @return   java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
    public Vector getOvtmHour( String empNo, String YYYYMM,  String iFlag,  D01OTData inputData ) throws GeneralException {
        JCO.Client mConnection = null ;

//PERNR,yymm,inputData.WORK_DATE,"R", inputData.AINF_SEQN,
//		inputData.STDAZ, inputData.PBEG1, inputData.PEND1, inputData.PBEG2, inputData.PEND2
//String empNo, String YYYYMM, String DATE, String iFlag, String AINF_SEQN,
        //String workTime, String restFrom1, String restTo1, String restFrom2, String restTo2

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, empNo, YYYYMM, inputData.WORK_DATE, iFlag, inputData.AINF_SEQN, inputData.STDAZ,
            		inputData.PBEG1, inputData.PEND1, inputData.PBEG2, inputData.PEND2) ;
            excute( mConnection, function ) ;

            Vector ret = getOutput2( function ) ;

            return ret ;
        } catch( Exception ex ) {
            Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
            throw new GeneralException( ex ) ;
        } finally {
            close( mConnection ) ;
        }
    }
    /**********************************************************************************************************/
    /** [WorkTime52]
     * 초과근무 내용을 가져오는 RFC를 호출하는 Method(신청 시 호출)
     *  @param   java.lang.String 사원번호
     *  @param  	java.lang.String iFlag  : 'C' = 현황, 'R' = 신청,'M' = 수정, 'G' = 결재
     *  @return   java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
    public Vector getOvtmHour52( String empNo, String YYYYMMDD,  String iFlag,  D01OTData inputData, String I_NTM ) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput52( function, empNo, YYYYMMDD, inputData.WORK_DATE, iFlag, inputData.AINF_SEQN, inputData.STDAZ,
            		inputData.PBEG1, inputData.PEND1, inputData.PBEG2, inputData.PEND2, I_NTM) ;
            excute( mConnection, function ) ;

            Vector ret = getOutput2( function ) ;

            return ret ;
        } catch( Exception ex ) {
            Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
            throw new GeneralException( ex ) ;
        } finally {
            close( mConnection ) ;
        }
    }

    /**********************************************************************************************************/

    /**
     * 초과근무 내용을 가져오는 RFC를 호출하는 Method(전일근태 체크 가능 여부 확인 용)
     *  @param     java.lang.String 사원번호
     *  @return    java.util.Vector
     *  @exception com.sns.jdf.GeneralException
     */
    public String getOvtmHour( String empNo, String YYYYMM, String DATE, String temp) throws GeneralException {
        JCO.Client mConnection = null ;

        try {
            mConnection = getClient() ;
            JCO.Function function = createFunction( functionName ) ;

            setInput( function, empNo, YYYYMM, DATE, temp) ;
            excute( mConnection, function ) ;

            String ret = getOutput3( function ) ;

            return ret ;
        } catch( Exception ex ) {
            Logger.sap.println( this, " SAPException : " + ex.toString() ) ;
            throw new GeneralException( ex ) ;
        } finally {
            close( mConnection ) ;
        }
    }

    /**
     * RFC 실행전에 Import 값을 setting 한다.
     * com.sns.jdf.SAPWrap.excute( JCO.Client mConnection, JCO.Function function ) 가 호출되기 전에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @exception      com.sns.jdf.GeneralException
     */
    private void setInput( JCO.Function function, String empNo, String YYYYMM ) throws GeneralException {
        String fieldName = "I_PERNR" ;
        setField( function, fieldName, empNo ) ;

        String fieldNam1 = "I_YYYYMM" ;
        setField( function, fieldNam1, YYYYMM ) ;

    }

    /**
     * [CSR ID:2803878] 초과근무 관련 개발 사항
     * 화면에 기존 신청 시간을 보여줌
     */
    private void setInput( JCO.Function function, String empNo, String YYYYMM, String iFlag ) throws GeneralException {
        String fieldName = "I_PERNR" ;
        setField( function, fieldName, empNo ) ;

        String fieldNam1 = "I_YYYYMM" ;
        setField( function, fieldNam1, YYYYMM ) ;//현재 년월

        String fieldNam2 = "I_FLAG" ; // C : 현황, R : 신청
        setField( function, fieldNam2, iFlag ) ;
    }



    /** [WorkTime52]
     * [CSR ID:2803878] 초과근무 관련 개발 사항
     * 화면에 기존 신청 시간을 보여줌
     */
    private void setInput2( JCO.Function function, String empNo, String I_DATE, String iFlag, String I_NTM ) throws GeneralException {
        String fieldName = "I_PERNR" ;
        setField( function, fieldName, empNo ) ;

        String fieldNam1 = "I_DATE" ;
        setField( function, fieldNam1, I_DATE ) ;//현재일자 및 초과근무신청일

        String fieldNam2 = "I_FLAG" ; // C : 현황, R : 신청
        setField( function, fieldNam2, iFlag ) ;

        String fieldNam3 = "I_NTM" ; // 신규 기존 optional value
        setField( function, fieldNam3, I_NTM ) ;

    }








    /**
     * [CSR ID:2803878] 초과근무 관련 개발 사항
     * 화면에 기존 신청 시간을 보여줌
     */
    private void setInput( JCO.Function function, String empNo, String YYYYMM, String DATE, String iFlag, String AINF_SEQN, String workTime, String restFrom1, String restTo1, String restFrom2, String restTo2 ) throws GeneralException {
        String fieldName = "I_PERNR" ;
        setField( function, fieldName, empNo ) ;

        String fieldNam1 = "I_YYYYMM" ;
        setField( function, fieldNam1, YYYYMM ) ;//현재 년월

        String fieldNam2 = "I_DATE" ; // 신청일(해당 일자가 포함된 주의 초과근무 신청 합계를 알기 위함
        setField( function, fieldNam2, DATE ) ;

        String fieldNam3 = "I_FLAG" ; // C : 현황, R : 신청,  M : 수정, G : 결재
        setField( function, fieldNam3, iFlag ) ;

        String fieldNam9 = "I_AINF_SEQN" ; // 결재번호(수정, 결재일 경우만 있음)
        setField( function, fieldNam9, AINF_SEQN ) ;

        String fieldName4 = "I_STDAZ" ;
        setField( function, fieldName4, workTime ) ;//근무하는 시간

        String fieldNam5 = "I_PBEG1" ;
        setField( function, fieldNam5, restFrom1 ) ;//휴식시간 from 1

        String fieldNam6 = "I_PEND1" ; // 휴식시간 to 1
        setField( function, fieldNam6, restTo1 ) ;

        String fieldNam7 = "I_PBEG2" ; // 휴식시간 from 2
        setField( function, fieldNam7, restFrom2 ) ;

        String fieldNam8 = "I_PEND2" ; //휴식시간 to 2
        setField( function, fieldNam8, restTo2 ) ;
    }




    /** [WorkTime52]
     * [CSR ID:2803878] 초과근무 관련 개발 사항
     * 화면에 기존 신청 시간을 보여줌
     */
    private void setInput52( JCO.Function function, String empNo, String YYYYMMDD, String DATE, String iFlag, String AINF_SEQN, String workTime, String restFrom1, String restTo1, String restFrom2, String restTo2, String I_NTM ) throws GeneralException {
        String fieldName = "I_PERNR" ;
        setField( function, fieldName, empNo ) ;

        String fieldNam1 = "I_YYYYMMDD" ;
        setField( function, fieldNam1, YYYYMMDD ) ;//현재 년월

        String fieldNam2 = "I_DATE" ; // 신청일(해당 일자가 포함된 주의 초과근무 신청 합계를 알기 위함
        setField( function, fieldNam2, DATE ) ;

        String fieldNam3 = "I_FLAG" ; // C : 현황, R : 신청,  M : 수정, G : 결재
        setField( function, fieldNam3, iFlag ) ;

        String fieldNam9 = "I_AINF_SEQN" ; // 결재번호(수정, 결재일 경우만 있음)
        setField( function, fieldNam9, AINF_SEQN ) ;

        String fieldName4 = "I_STDAZ" ;
        setField( function, fieldName4, workTime ) ;//근무하는 시간

        String fieldNam5 = "I_PBEG1" ;
        setField( function, fieldNam5, restFrom1 ) ;//휴식시간 from 1

        String fieldNam6 = "I_PEND1" ; // 휴식시간 to 1
        setField( function, fieldNam6, restTo1 ) ;

        String fieldNam7 = "I_PBEG2" ; // 휴식시간 from 2
        setField( function, fieldNam7, restFrom2 ) ;

        String fieldNam8 = "I_PEND2" ; //휴식시간 to 2
        setField( function, fieldNam8, restTo2 ) ;

        String fieldNam10 = "I_NTM" ; //휴식시간 to 2
        setField( function, fieldNam10, I_NTM ) ;
    }


















    /**
     * [CSR ID:2803878] 초과근무 관련 개발 사항
     * 화면에 기존 신청 시간을 보여줌
     */
    private void setInput( JCO.Function function, String empNo, String YYYYMM, String I_DATE, String temp ) throws GeneralException {
        String fieldName = "I_PERNR" ;
        setField( function, fieldName, empNo ) ;

        String fieldNam1 = "I_YYYYMM" ;
        setField( function, fieldNam1, YYYYMM ) ;//현재 년월

        String fieldNam2 = "I_DATE" ; //
        setField( function, fieldNam2, I_DATE ) ;
    }



    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute( JCO.Client mConnection, JCO.Function function ) 가 호출된후에 실행되어야하는 메소드
     * @@급여에서 쓰던 원래 공수 용 function@@
     * @param function com.sap.mw.jco.JCO.Function
     * @return         java.util.Vector
     * @exception      com.sns.jdf.GeneralException
     */
    private String getOutput( JCO.Function function ) throws GeneralException {
//      Export 변수 조회
        String fieldName1      = "E_KONGSU_HOUR";      // 개근연차계
        String P_KONGSU_HOUR   = getField(fieldName1, function) ;

        Logger.sap.println( this, " P_KONGSU_HOUR : " + P_KONGSU_HOUR ) ;
        return P_KONGSU_HOUR;
    }

    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute( JCO.Client mConnection, JCO.Function function ) 가 호출된후에 실행되어야하는 메소드
     * @@화면 처음 로딩할 때 기본 정보들 불러오는 function@@
     * @param function com.sap.mw.jco.JCO.Function
     * @return         java.util.Vector
     * @exception      com.sns.jdf.GeneralException
     */
    private Vector getOutput1( JCO.Function function ) throws GeneralException {

    	Vector ret = new Vector();
    	//      Export 변수 조회
        String fieldName      = "E_KONGSU_HOUR";      // 개근연차계
        String P_KONGSU_HOUR   = getField(fieldName, function) ;

        //[CSR ID:2803878] 초과근무 관련 수정요
        String fieldName1      = "E_YUNJANG";      // 평일연장
        String YUNJANG   = getField(fieldName1, function) ;
        String fieldName2      = "E_HTKGUN";      // 휴일근로
        String HTKGUN   = getField(fieldName2, function) ;
        String fieldName3      = "E_HYUNJANG";      // 휴일연장
        String HYUNJANG   = getField(fieldName3, function) ;
        String fieldName4      = "E_YAGAN";      // 야간근로
        String YAGAN   = getField(fieldName4, function) ;
        String fieldName5      = "E_NOAPP";      // 미결재 항목
        String NOAPP   = getField(fieldName5, function) ;

        // [KJI2015042703] 초과근무 수정
        String fieldName6      = "E_MONTH";      //현황 상단에 월 표기(전월 21 ~ 당 월 20)
        String MONTH   = getField(fieldName6, function) ;

        ret.addElement(P_KONGSU_HOUR);
        ret.addElement(YUNJANG);
        ret.addElement(HTKGUN);
        ret.addElement(HYUNJANG);
        ret.addElement(YAGAN);
        ret.addElement(NOAPP);
        ret.addElement(MONTH);

        return ret;
    }

    /**
    * RFC 실행후 Export 값을 Vector 로 Return 한다.
    * 반드시 com.sns.jdf.SAPWrap.excute( JCO.Client mConnection, JCO.Function function ) 가 호출된후에 실행되어야하는 메소드
    * @@신청 버튼 누를 때 타는 function@@
    * @param function com.sap.mw.jco.JCO.Function
    * @return         java.util.Vector
    * @exception      com.sns.jdf.GeneralException
    */
   private Vector getOutput2( JCO.Function function ) throws GeneralException {

	   Vector ret = new Vector();
   	//      Export 변수 조회
       String fieldName      = "E_YN_FLAG";      // 'Y' = 12시간 미만, 'N' = 12시간 이상 (신청일 포함한 주에 신청된 total 초과근무 신청시간)
       String YN_FLAG   = getField(fieldName, function) ;

       //신청하고 있는 순간의 값도 포함하여 생산직의 경우 주당(월~일) 초과근무 시간, 사무직의 경우 월당(전달 21부터 이번 달 20일 기준) 초과근무 시간 신청한 총 값을 계산
       String fieldName1 = "E_SUM";
       String SUM = getField(fieldName1, function);

       //신청자가 사무직인지 생산직인지 구분하는 flag(생산직 : P, 사무직 : O)
       String fieldName2 = "E_PERSON_FLAG";
       String PERSON_FLAG = getField(fieldName2, function);

       //전일 근태에 포함 체크박스를 해도 되는 대상인지 체크(N일 경우 신청 불가대상임.)
       String filedName3 = "E_PRECHECK";
       String PRECHECK = getField(filedName3, function);

       String fieldName4      = "E_MONTH";      // 신청/수정 시 popup에 신청일 기준으로 월 표기
       String MONTH   = getField(fieldName4, function) ;

       ret.addElement(YN_FLAG);
       ret.addElement(SUM);
       ret.addElement(PERSON_FLAG);
       ret.addElement(PRECHECK);
       ret.addElement(MONTH);

       return ret;
   }

   /**
    * RFC 실행후 Export 값을 Vector 로 Return 한다.
    * 반드시 com.sns.jdf.SAPWrap.excute( JCO.Client mConnection, JCO.Function function ) 가 호출된후에 실행되어야하는 메소드
    * @@신청 버튼 누를 때 타는 function@@
    * @param function com.sap.mw.jco.JCO.Function
    * @return         java.util.Vector
    * @exception      com.sns.jdf.GeneralException
    */
   private String getOutput3( JCO.Function function ) throws GeneralException {
   	//      Export 변수 조회
       String fieldName   = "E_PRECHECK";
       String PRECHECK = getField(fieldName, function);

       return PRECHECK;
   }

   //[CSR ID:3043406] 급여명세표 내 공수 현황 기준 변경 요청
   private Vector getOutput4( JCO.Function function ) throws GeneralException {
	   Vector ret = new Vector();
//     Export 변수 조회
       String fieldName1      = "E_KONGSU_HOUR";      // 시간공수
       String P_KONGSU_HOUR   = getField(fieldName1, function) ;
       String fieldName2      = "E_KONGSU_HOUR2";      // 금액공수
       String E_KONGSU_HOUR2   = getField(fieldName2, function) ;

       ret.addElement(P_KONGSU_HOUR);
       ret.addElement(E_KONGSU_HOUR2);

       Logger.sap.println( this, " P_KONGSU_HOUR : " + P_KONGSU_HOUR ) ;
       return ret;
   }

}
