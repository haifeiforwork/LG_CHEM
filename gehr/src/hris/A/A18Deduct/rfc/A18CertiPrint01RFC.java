package hris.A.A18Deduct.rfc ;

import java.util.* ;

import com.sap.mw.jco.* ;
import com.sns.jdf.* ;
import com.sns.jdf.sap.* ;
import com.sns.jdf.util.* ;

import hris.A.A18Deduct.* ;
import hris.D.D11TaxAdjust.D11TaxAdjustPreWorkData;

/**
 *  A18CertiPrint01RFC.java
 *  근로소득원천징수영수증:T_RESULT를 가져오는 RFC를 호출하는 Class
 *
 * @author  김도신
 * @version 1.0, 2005/09/29
 */
public class A18CertiPrint01RFC extends SAPWrap {

    private String functionName = "ZHRP_RFC_READ_YEA_RESULT_PRINT" ;

    /**
     * 연말정산 결과내역를 가져오는 RFC 호출하는 Method
     * @return java.util.Vector
     * @param empNo java.lang.String 사원번호
     * @exception com.sns.jdf.GeneralException
     */
    public Vector detail( String empNo ) throws GeneralException {

        JCO.Client mConnection = null;
        try{
            mConnection = getClient();
            JCO.Function function = createFunction(functionName) ;

            setInput(function, empNo);
            excute(mConnection, function);
            
            return getOutput( function );
         } catch(Exception ex){
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
     * @param empNo java.lang.String 사번
     * @exception com.sns.jdf.GeneralException
     */
    private void setInput(JCO.Function function, String empNo) throws GeneralException {
        String fieldName1 = "I_PERNR";
        setField( function, fieldName1, empNo );
    }
// Export Return type이 Vector 인 경우 중 Vector의 Element type 가 com.sns.jdf.util.CodeEntity 일 경우 2
// ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    /**
     * RFC 실행후 Export 값을 Vector 로 Return 한다.
     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드
     * @param function com.sap.mw.jco.JCO.Function
     * @return java.util.Vector
     * @exception com.sns.jdf.GeneralException
     */
    private Vector getOutput(JCO.Function function) throws GeneralException {
        Vector ret = new Vector();

//      Table 조회
        String entityName      = "hris.A.A18Deduct.A18CertiPrintPreWorkData";
        Vector T_PREWORK       = getTable(entityName,  function, "T_PREWORK");
        String entityName2     = "hris.A.A18Deduct.A18CertiPrintBusiData";
        Vector T_BUSINESSPLACE = getTable(entityName2, function, "T_BUSINESSPLACE");

        String tableName       = "T_RESULT";   // RFC Export 구성요소 참조
        String codeField       = "LGART";      // RFC Export table의 field 구성요소 중 CodeEntity의 "code" 가 될 Field Name 
        String valueField      = "BETRG";      // RFC Export table의 field 구성요소 중 CodeEntity의 "value" 가 될 Field Name 
        Vector T_RESULT        = getCodeVector( function, tableName, codeField, valueField );
        
        //A18CertiPrintPreWorkData dataPre = new A18CertiPrintPreWorkData();
        //if( T_PREWORK.size()       > 0 )
        //{     dataPre = (A18CertiPrintPreWorkData)T_PREWORK.get(0); 

        for( int i = 0 ; i < T_PREWORK.size() ; i++ ){
        	A18CertiPrintPreWorkData dataPre = (A18CertiPrintPreWorkData)T_PREWORK.get(i);        
		        if(dataPre.BET01.equals("")){ dataPre.BET01=""; }else{ dataPre.BET01=Double.toString(Double.parseDouble(dataPre.BET01) * 100.0); }  // 금액
		        if(dataPre.BET02.equals("")){ dataPre.BET02=""; }else{ dataPre.BET02=Double.toString(Double.parseDouble(dataPre.BET02) * 100.0); }  // 금액
		        if(dataPre.BET03.equals("")){ dataPre.BET03=""; }else{ dataPre.BET03=Double.toString(Double.parseDouble(dataPre.BET03) * 100.0); }  // 금액
		        if(dataPre.BET04.equals("")){ dataPre.BET04=""; }else{ dataPre.BET04=Double.toString(Double.parseDouble(dataPre.BET04) * 100.0); }  // 금액
		        if(dataPre.BET05.equals("")){ dataPre.BET05=""; }else{ dataPre.BET05=Double.toString(Double.parseDouble(dataPre.BET05) * 100.0); }  // 금액
		        if(dataPre.BET06.equals("")){ dataPre.BET06=""; }else{ dataPre.BET06=Double.toString(Double.parseDouble(dataPre.BET06) * 100.0); }  // 금액
		        if(dataPre.BET07.equals("")){ dataPre.BET07=""; }else{ dataPre.BET07=Double.toString(Double.parseDouble(dataPre.BET07) * 100.0); }  // 금액
		        if(dataPre.BET08.equals("")){ dataPre.BET08=""; }else{ dataPre.BET08=Double.toString(Double.parseDouble(dataPre.BET08) * 100.0); }  // 금액
		        if(dataPre.BET09.equals("")){ dataPre.BET09=""; }else{ dataPre.BET09=Double.toString(Double.parseDouble(dataPre.BET09) * 100.0); }  // 금액
		        if(dataPre.BET10.equals("")){ dataPre.BET10=""; }else{ dataPre.BET10=Double.toString(Double.parseDouble(dataPre.BET10) * 100.0); }  // 금액
		        if(dataPre.BET11.equals("")){ dataPre.BET11=""; }else{ dataPre.BET11=Double.toString(Double.parseDouble(dataPre.BET11) * 100.0); }  // 금액
		        if(dataPre.BET12.equals("")){ dataPre.BET12=""; }else{ dataPre.BET12=Double.toString(Double.parseDouble(dataPre.BET12) * 100.0); }  // 금액
		        if(dataPre.BET13.equals("")){ dataPre.BET13=""; }else{ dataPre.BET13=Double.toString(Double.parseDouble(dataPre.BET13) * 100.0); }  // 금액
		        if(dataPre.BET14.equals("")){ dataPre.BET14=""; }else{ dataPre.BET14=Double.toString(Double.parseDouble(dataPre.BET14) * 100.0); }  // 금액
		        if(dataPre.BET15.equals("")){ dataPre.BET15=""; }else{ dataPre.BET15=Double.toString(Double.parseDouble(dataPre.BET15) * 100.0); }  // 금액
		        if(dataPre.BET16.equals("")){ dataPre.BET16=""; }else{ dataPre.BET16=Double.toString(Double.parseDouble(dataPre.BET16) * 100.0); }  // 금액
		        if(dataPre.BET17.equals("")){ dataPre.BET17=""; }else{ dataPre.BET17=Double.toString(Double.parseDouble(dataPre.BET17) * 100.0); }  // 금액
		        if(dataPre.BET18.equals("")){ dataPre.BET18=""; }else{ dataPre.BET18=Double.toString(Double.parseDouble(dataPre.BET18) * 100.0); }  // 금액
		        if(dataPre.BET19.equals("")){ dataPre.BET19=""; }else{ dataPre.BET19=Double.toString(Double.parseDouble(dataPre.BET19) * 100.0); }  // 금액
		        if(dataPre.BET20.equals("")){ dataPre.BET20=""; }else{ dataPre.BET20=Double.toString(Double.parseDouble(dataPre.BET20) * 100.0); }  // 금액
		        if(dataPre.BET21.equals("")){ dataPre.BET21=""; }else{ dataPre.BET21=Double.toString(Double.parseDouble(dataPre.BET21) * 100.0); }  // 금액
		        if(dataPre.BET22.equals("")){ dataPre.BET22=""; }else{ dataPre.BET22=Double.toString(Double.parseDouble(dataPre.BET22) * 100.0); }  // 금액
		        if(dataPre.BET23.equals("")){ dataPre.BET23=""; }else{ dataPre.BET23=Double.toString(Double.parseDouble(dataPre.BET23) * 100.0); }  // 금액
		        if(dataPre.BET24.equals("")){ dataPre.BET24=""; }else{ dataPre.BET24=Double.toString(Double.parseDouble(dataPre.BET24) * 100.0); }  // 금액
		        if(dataPre.BET25.equals("")){ dataPre.BET25=""; }else{ dataPre.BET25=Double.toString(Double.parseDouble(dataPre.BET25) * 100.0); }  // 금액
		        if(dataPre.BET26.equals("")){ dataPre.BET26=""; }else{ dataPre.BET26=Double.toString(Double.parseDouble(dataPre.BET26) * 100.0); }  // 금액
		        if(dataPre.BET27.equals("")){ dataPre.BET27=""; }else{ dataPre.BET27=Double.toString(Double.parseDouble(dataPre.BET27) * 100.0); }  // 금액
		        if(dataPre.BET28.equals("")){ dataPre.BET28=""; }else{ dataPre.BET28=Double.toString(Double.parseDouble(dataPre.BET28) * 100.0); }  // 금액
		        if(dataPre.BET29.equals("")){ dataPre.BET29=""; }else{ dataPre.BET29=Double.toString(Double.parseDouble(dataPre.BET29) * 100.0); }  // 금액
		        if(dataPre.BET30.equals("")){ dataPre.BET30=""; }else{ dataPre.BET30=Double.toString(Double.parseDouble(dataPre.BET30) * 100.0); }  // 금액
		        if(dataPre.BET31.equals("")){ dataPre.BET31=""; }else{ dataPre.BET31=Double.toString(Double.parseDouble(dataPre.BET31) * 100.0); }  // 금액
		        if(dataPre.BET32.equals("")){ dataPre.BET32=""; }else{ dataPre.BET32=Double.toString(Double.parseDouble(dataPre.BET32) * 100.0); }  // 금액
		        if(dataPre.BET33.equals("")){ dataPre.BET33=""; }else{ dataPre.BET33=Double.toString(Double.parseDouble(dataPre.BET33) * 100.0); }  // 금액
		        if(dataPre.BET34.equals("")){ dataPre.BET34=""; }else{ dataPre.BET34=Double.toString(Double.parseDouble(dataPre.BET34) * 100.0); }  // 금액
		        if(dataPre.BET35.equals("")){ dataPre.BET35=""; }else{ dataPre.BET35=Double.toString(Double.parseDouble(dataPre.BET35) * 100.0); }  // 금액
		        if(dataPre.BET36.equals("")){ dataPre.BET36=""; }else{ dataPre.BET36=Double.toString(Double.parseDouble(dataPre.BET36) * 100.0); }  // 금액
		        if(dataPre.BET37.equals("")){ dataPre.BET37=""; }else{ dataPre.BET37=Double.toString(Double.parseDouble(dataPre.BET37) * 100.0); }  // 금액
		        if(dataPre.BET38.equals("")){ dataPre.BET38=""; }else{ dataPre.BET38=Double.toString(Double.parseDouble(dataPre.BET38) * 100.0); }  // 금액
		        if(dataPre.BET39.equals("")){ dataPre.BET39=""; }else{ dataPre.BET39=Double.toString(Double.parseDouble(dataPre.BET39) * 100.0); }  // 금액
		        if(dataPre.BET40.equals("")){ dataPre.BET40=""; }else{ dataPre.BET40=Double.toString(Double.parseDouble(dataPre.BET40) * 100.0); }  // 금액
		        if(dataPre.BET41.equals("")){ dataPre.BET41=""; }else{ dataPre.BET41=Double.toString(Double.parseDouble(dataPre.BET41) * 100.0); }  // 금액
		        if(dataPre.BET42.equals("")){ dataPre.BET42=""; }else{ dataPre.BET42=Double.toString(Double.parseDouble(dataPre.BET42) * 100.0); }  // 금액
		        if(dataPre.BET43.equals("")){ dataPre.BET43=""; }else{ dataPre.BET43=Double.toString(Double.parseDouble(dataPre.BET43) * 100.0); }  // 금액
		        if(dataPre.BET44.equals("")){ dataPre.BET44=""; }else{ dataPre.BET44=Double.toString(Double.parseDouble(dataPre.BET44) * 100.0); }  // 금액
		        if(dataPre.BET45.equals("")){ dataPre.BET45=""; }else{ dataPre.BET45=Double.toString(Double.parseDouble(dataPre.BET45) * 100.0); }  // 금액                  
/*	          dataPre.SAL01 = Double.toString(Double.parseDouble(dataPre.SAL01) * 100.0);          // 종전근무지의 정규급여 
	          dataPre.BON01 = Double.toString(Double.parseDouble(dataPre.BON01) * 100.0);          // 종전근무지의 상여   
	          dataPre.ABN01 = Double.toString(Double.parseDouble(dataPre.ABN01) * 100.0);          // 종전근무지의 확인상여   
	          dataPre.STK01 = Double.toString(Double.parseDouble(dataPre.STK01) * 100.0);          // 종전근무지의 스톡 옵션   
	          dataPre.SAL02 = Double.toString(Double.parseDouble(dataPre.SAL02) * 100.0);          // 종전근무지의 정규급여 
	          dataPre.BON02 = Double.toString(Double.parseDouble(dataPre.BON02) * 100.0);          // 종전근무지의 상여   
	          dataPre.ABN02 = Double.toString(Double.parseDouble(dataPre.ABN02) * 100.0);          // 종전근무지의 확인상여   
	          dataPre.STK02 = Double.toString(Double.parseDouble(dataPre.STK02) * 100.0);          // 종전근무지의 스톡 옵션   
              */
        }
        A18CertiPrintBusiData    dataBus = new A18CertiPrintBusiData();
        if( T_BUSINESSPLACE.size() > 0 ) {     dataBus = (A18CertiPrintBusiData)T_BUSINESSPLACE.get(0);     }
        
        A18CertiPrint01Data data = (A18CertiPrint01Data)matchData(T_RESULT);

//      Export 변수 조회
        String fieldName = "E_PERIOD" ;
        String E_PERIOD  = getField(fieldName, function);

       // ret.addElement(dataPre);
        ret.addElement(T_PREWORK);
        ret.addElement(dataBus);
        ret.addElement(data);
        ret.addElement(E_PERIOD);

        String entityName3     = "hris.A.A18Deduct.A18CertiPrintPreWorkNmData";
        Vector T_LGART_LIST = getTable(entityName3, function, "T_LGART_LIST");
        ret.addElement(T_LGART_LIST);
        return ret;
    }

//  
    private Object matchData(Vector ret) throws GeneralException {
        A18CertiPrint01Data retData = new A18CertiPrint01Data();

        double _주식매수선택권행사이익종전 = 0 ; // "/P18"
        double _주식매수선택권행사이익종현 = 0  ; // "/Y18"
        double _비과세소득_야간근로수당종전 = 0 ; // "/P06"
        double _비과세소득_야간근로수당종현 = 0  ; // "/Y1E"
         
        for( int i = 0 ; i < ret.size() ; i++ ) {
            CodeEntity data = (CodeEntity)ret.get(i);
            double d_value = 0;
            
            if(data.value.equals("")) {
              d_value = 0;
            } else { 
              d_value = Double.parseDouble(data.value) * 100.0;          // 100을 곱해서 변환해준다. 
            }

            if(data.code.equals("/P03")){           // 급여총액
                retData._종전_소득세 = d_value; 
            } else if(data.code.equals("/P04")){           // 급여총액
                retData._종전_주민세 = d_value; 
            } else if(data.code.equals("/Y1A")){           // 급여총액
                retData._급여총액 = d_value; 
            } else if(data.code.equals("/Y1B")){    // 상여총액
                retData._상여총액 = d_value; 
            } else if(data.code.equals("/Y1C")){    // 인정상여
                retData._인정상여 = d_value; 
            } else if(data.code.equals("/Y18")){    // 주식매수선택권행사이익 09.02.03 add   
                _주식매수선택권행사이익종현 = d_value; 
            } else if(data.code.equals("/P18")){    // 주식매수선택권행사이익종전 10.02.03 add   
                _주식매수선택권행사이익종전 = d_value; 
            } else if(data.code.equals("/Y22")){    // _우리사주조합인출금 10.02.04 add     
                retData._우리사주조합인출금 = d_value; 
            } else if(data.code.equals("/Y1K")){    // 비과세소득_연구활동비 09.02.03 add
                retData._비과세소득_연구활동비 = d_value; 
            } else if(data.code.equals("/Y16")){    // 비과세소득_출산보육수당 09.02.03 add
                retData._비과세소득_출산보육수당 = d_value; 
            } else if(data.code.equals("/Y15")){    // 비과세소득_외국인근로자 09.02.03 add
                retData._비과세소득_외국인근로자 = d_value; 
            } else if(data.code.equals("/Y1G")){    // 비과세소득-국외근로
                retData._비과세소득_국외근로 = d_value; 
            } else if(data.code.equals("/Y1E")){    // 비과세소득-야간근로수당 등
                _비과세소득_야간근로수당종현 = d_value; 
            } else if(data.code.equals("/P06")){    // 비과세소득-야간근로수당 등
            	_비과세소득_야간근로수당종전 = d_value;                
            } else if(data.code.equals("/Y1F")){    // 비과세소득-기타비과세
                retData._비과세소득_기타비과세 = d_value; 
            } else if(data.code.equals("/Y1T")){    // 총급여
                retData._총급여 = d_value; 
            } else if(data.code.equals("/Y2D")){    // 근로소득공제
                retData._근로소득공제 = d_value; 
            } else if(data.code.equals("/Y2E")){    // 과세대상근로소득금액
                retData._근로소득금액 = d_value; 
            } else if(data.code.equals("/Y3E")){    // 기본공제- 본인
                retData._기본공제_본인 = d_value; 
            } else if(data.code.equals("/Y3G")){    // 기본공제-배우자
                retData._기본공제_배우자 = d_value; 
            } else if(data.code.equals("/Y3P")){    // 기본공제-부양가족
                retData._기본공제_부양가족 = d_value; 
            } else if(data.code.equals("/Y3S") || data.code.equals("/Y3U")){    // 추가공제-경로우대 + 추가공제-경로우대(70세이상)
                retData._추가공제_경로우대 = retData._추가공제_경로우대+d_value; 
            } else if(data.code.equals("/Y3T")){    // 추가공제-장애인
                retData._추가공제_장애인 = d_value; 
            } else if(data.code.equals("/Y3V")){    // 추가공제-부녀자
                retData._추가공제_부녀자 = d_value; 
            } else if(data.code.equals("/Y3X")){    // 추가공제-자녀양육비
                retData._추가공제_자녀양육비 = d_value; 
            } else if(data.code.equals("/Y3W")){    // 추가공제_출산입양자  09.02.03 add
                retData._추가공제_출산입양자 = d_value; 
            } else if(data.code.equals("/Y3Z")){    // 소수공제자추가공제
                retData._소수공제자추가공제 = d_value; 
            } else if(data.code.equals("/Y6A")){    // 연금보험료공제
                retData._연금보험료공제 = d_value; 
            } else if(data.code.equals("/Y4C")){    // 특별공제-보험료
                retData._특별공제_보험료 = d_value; 
            } else if(data.code.equals("/Y4H")){    // 특별공제-의료비
                retData._특별공제_의료비 = d_value; 
            } else if(data.code.equals("/Y4M")){    // 특별공제-교육비
                retData._특별공제_교육비 = d_value; 
            } else if(data.code.equals("/Y5G")){    // 특별공제-주택자금
                retData._특별공제_주택자금 = d_value; 
            } else if(data.code.equals("/Y5L")){    // 특별공제-주택임차차입금원리금상환액  09.02.03 add
                retData._특별공제_주택임차차입금원리금상환액 = d_value;               
            } else if(data.code.equals("/Y54")){    // 특별공제-장기주택저당차입금이자상환액  09.02.03 add
                retData._특별공제_장기주택저당차입금이자상환액 = d_value; 
            } else if(data.code.equals("/Y5S")){    // 기부금공제계산
                retData._특별공제_기부금 = d_value; 
            } else if(data.code.equals("/Y5U")){    // 경조사비(혼인·장례·이사비)
                retData._특별공제_혼인이사장례비 = d_value; 
            } else if(data.code.equals("/Y5Z")){
                retData._표준공제 = d_value; 
            } else if(data.code.equals("/Y6B")){    // Y6B
                retData._Y6B = d_value; 
            } else if(data.code.equals("/Y6I")){    // 개인연금저축소득공제
                retData._개인연금저축소득공제 = d_value; 
            } else if(data.code.equals("/Y6Q")){    // 연금저축소득공제
                retData._연금저축소득공제 = d_value; 
            } else if(data.code.equals("/Y6V")){    // 투자조합출자등소득공제
                retData._투자조합출자등소득공제 = d_value; 
            } else if(data.code.equals("/Y6M")){    // 신용카드공제
                retData._신용카드공제 = d_value; 
            } else if(data.code.equals("/Y6N")){    // _기타연금보험료공제 09.02.03 add
                retData._기타연금보험료공제 = d_value; 
            } else if(data.code.equals("/Y6S")){    // _퇴직연금소득공제 09.02.03 add
                retData._퇴직연금소득공제 = d_value; 
            } else if(data.code.equals("/Y7U")){    // 소상공인공제부금소득공제 09.02.03 add
                retData._소상공인공제부금소득공제 = d_value; 
            } else if(data.code.equals("/Y5E")){    // 주택마련저축소득공제 09.02.03 add
                retData._주택마련저축소득공제 = d_value; 
            } else if(data.code.equals("/Y7W")){    // 장기주식형저축소득공제 09.02.03 add
                retData._장기주식형저축소득공제 = d_value; 
            } else if(data.code.equals("/Y7B")){    // 종합소득과세표준
                retData._종합소득과세표준 = d_value; 
            } else if(data.code.equals("/Y7C")){    // 산출세액
                retData._산출세액 = d_value; 
            } else if(data.code.equals("/Y7Q")){    // 세액감면-소득세법정산
                retData._세액감면_소득세법정산 = d_value; 
            } else if(data.code.equals("/Y7V")){    // 납세조합공제
                retData._납세조합공제 = d_value; 
            } else if(data.code.equals("/Y7R")){    // 세액감면-조세특례제한법
                retData._세액감면_조세특례제한법 = d_value; 
            } else if(data.code.equals("/Y7E")){    // 세액공제-근로소득
                retData._세액공제_근로소득 = d_value; 
            } else if(data.code.equals("/Y7G")){    // 세액공제-주택차입금
                retData._세액공제_주택차입금 = d_value; 
            } else if(data.code.equals("/Y7I")){    // 세액공제-근로자주식저축
                retData._세액공제_근로자주식저축 = d_value; 
            } else if(data.code.equals("/Y7M")){    // 세액공제-외국납부
                retData._세액공제_외국납부 = d_value; 
            } else if(data.code.equals("/Y7N")){    // 정치기부금
                retData._세액공제_기부정치자금 = d_value;
            } else if(data.code.equals("/Y7V")){    // _납세조합공제
                retData._납세조합공제 = d_value;
//            } else if(data.code.equals("/Y7J")){    // 세액공제-장기증권저축
//                retData._장기증권저축 = d_value;
            } else if(data.code.equals("/Y8I")){    // 결정세액(갑근세)_원단위 절사
               // retData._결정세액_갑근세 = d_value - (d_value % 10); 
               retData._결정세액_갑근세 = d_value;
            } else if(data.code.equals("/Y8R")){    // 결정세액(주민세)_원단위 절사
                //retData._결정세액_주민세 = d_value - (d_value % 10); 
            	retData._결정세액_주민세 = d_value;
            } else if(data.code.equals("/Y8S")){    // 결정세액(농특세)_원단위 절사
                //retData._결정세액_농특세 = d_value - (d_value % 10); 
            	retData._결정세액_농특세 = d_value;
            } else if(data.code.equals("/Y9I")){    // 기납부세액(갑근세)
                retData._기납부세액_갑근세 = d_value; 
            } else if(data.code.equals("/Y9R")){    // 기납부세액(주민세)
                retData._기납부세액_주민세 = d_value; 
            } else if(data.code.equals("/Y9S")){    // 기납부세액(농특세)
                retData._기납부세액_농특세 = d_value; 
            } else if(data.code.equals("/YAI")){    // 차감징수세액(갑근세)
                retData._차감징수세액_갑근세 = d_value; 
            } else if(data.code.equals("/YAR")){    // 차감징수세액(주민세)
                retData._차감징수세액_주민세 = d_value; 
            } else if(data.code.equals("/YAS")){    // 차감징수세액(농특세)
                retData._차감징수세액_농특세 = d_value; 
            } else if(data.code.equals("/Y42")){    // 건강보험
                retData._건강보험 = d_value; 
            } else if(data.code.equals("/Y44")){    // 고용보험 
                retData._고용보험 = d_value; 
            }
        }
 
        retData._주식매수선택권행사이익 = _주식매수선택권행사이익종현 - _주식매수선택권행사이익종전;
        retData._비과세소득_야간근로수당 =  _비과세소득_야간근로수당종현 -_비과세소득_야간근로수당종전; 
        retData._그밖의소득공제계 = retData._Y6B -  retData._종합소득과세표준; // "=/Y6B - /Y7B"  09.02.03 add
        retData._국민연금보험료공제 = retData._연금보험료공제 -  retData._기타연금보험료공제; // "=/Y6A - /Y6N"  09.02.03 add
        retData._비과세소득_기타비과세 = retData._비과세소득_기타비과세-(retData._비과세소득_출산보육수당 +retData._비과세소득_외국인근로자 +retData._비과세소득_연구활동비);
//      비과세소득 합계   09.02.03 add
        retData._비과세소득_합계 = retData._비과세소득_국외근로 + retData._비과세소득_야간근로수당 + retData._비과세소득_기타비과세
                                           + retData._비과세소득_연구활동비 + retData._비과세소득_출산보육수당 + retData._비과세소득_외국인근로자;
//      특별공제 합계 09.02.03 add
        retData._특별공제_계 = retData._특별공제_보험료   + retData._특별공제_의료비 + retData._특별공제_교육비 
                             //      09.02.03 delete+ retData._특별공제_주택자금 
                             + retData._특별공제_기부금 + retData._특별공제_혼인이사장례비
                             + retData._특별공제_장기주택저당차입금이자상환액 + retData._특별공제_주택임차차입금원리금상환액;
//      차감소득금액
        retData._차감소득금액 = retData._근로소득금액 
                              - (retData._기본공제_본인      + retData._기본공제_배우자 + retData._기본공제_부양가족 +
                                 retData._추가공제_경로우대  + retData._추가공제_장애인 + retData._추가공제_부녀자   + retData._추가공제_자녀양육비
                                 + retData._추가공제_출산입양자
                                 + retData._소수공제자추가공제 
                                 // 09.02.03 delete + retData._연금보험료공제  
                                 + retData._국민연금보험료공제  + retData._기타연금보험료공제  + retData._퇴직연금소득공제 
                                 + retData._표준공제          + 
                                 retData._특별공제_보험료    + retData._특별공제_의료비 + retData._특별공제_교육비   
                                // 09.02.03 delete  + retData._특별공제_주택자금 
                                 + retData._특별공제_기부금    + retData._특별공제_혼인이사장례비
                                 + retData._특별공제_장기주택저당차입금이자상환액 + retData._특별공제_주택임차차입금원리금상환액);
//      세액감면 합계
        retData._세액감면_감면세액계 = retData._세액감면_소득세법정산 + retData._세액감면_조세특례제한법;
//      세액공제 합계
        retData._세액공제_세액공제계 = retData._세액공제_근로소득 + retData._세액공제_주택차입금 + retData._세액공제_근로자주식저축 
                                     + retData._세액공제_외국납부 + retData._세액공제_기부정치자금;
//      결정세액 합계 
        retData._결정세액_합계 = retData._결정세액_갑근세 + retData._결정세액_주민세 + retData._결정세액_농특세;
//      _종전근무지 합계
        retData._종전_합계 = retData._종전_소득세 + retData._종전_주민세;
//      기납부세액 합계
        retData._기납부세액_합계 = retData._기납부세액_갑근세 + retData._기납부세액_주민세 + retData._기납부세액_농특세;
//      차감징수세액 합계
        retData._차감징수세액_합계 =retData. _차감징수세액_갑근세 + retData._차감징수세액_주민세 + retData._차감징수세액_농특세;

        return retData ;
    }
}