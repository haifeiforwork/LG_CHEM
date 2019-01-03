package hris.common.rfc ;import java.util.* ;import com.sap.mw.jco.* ;import com.sns.jdf.* ;import com.sns.jdf.sap.* ;import hris.common.util.PdfUtil;/** * PdfParseRFC.java * 연말정산 - 국세청 PDF 파일 반영 RFC를 호출하는 Class * * @author 손혜영 * @version 1.0, 2013/07/01 */public class PdfParseRFC_2015 extends SAPWrap {    private static String functionName = "ZSOLYR_RFC_PDF_UPLOAD" ;    /**     * 연말정산 - 국세청 PDF 파일 반영 RFC 호출하는 Method     * @return java.util.Vector     * @exception com.sns.jdf.GeneralException     */    public Vector build( String empNo, String targetYear, Map map) throws GeneralException {        JCO.Client mConnection = null;        try{            mConnection = getClient();            JCO.Function function = createFunction(functionName) ;            setInput(function, empNo, targetYear);            //해당 테이블 별로 데이터 셋팅            for(int i=0;i<PdfUtil.tableNmArr.length;i++){            	Vector vec = (Vector)map.get(PdfUtil.tableNmArr[i]);            	if(vec!=null){            		setInput(function, vec, PdfUtil.tableNmArr[i]);            		//입력데이터 찍기            		//Logger.debug(vec);            	}            }            excute(mConnection, function);            Vector ret = getOutput(function);            return ret;        } catch(Exception ex){            Logger.sap.println(this, "SAPException : "+ex.toString());            //Logger.error(e);            throw new GeneralException(ex);        } finally {            close(mConnection);        }    }    /**     * RFC 실행전에 Import 값을 setting 한다.     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드     * @param function com.sap.mw.jco.JCO.Function     * @exception com.sns.jdf.GeneralException     */    private void setInput(JCO.Function function, String empNo, String targetYear) throws GeneralException {        String fieldName1 = "I_PERNR";        setField( function, fieldName1, empNo );        String fieldName2 = "I_YEAR";        setField( function, fieldName2, targetYear );    }    /**     * RFC 실행전에 Import 값을 setting 한다.     * com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출되기 전에 실행되어야하는 메소드     * @param function com.sap.mw.jco.JCO.Function     * @param entityVector java.util.Vector     * @exception com.sns.jdf.GeneralException     */    private void setInput(JCO.Function function, Vector entityVector, String tableName) throws GeneralException {        setTable(function, tableName, entityVector);    }    /**     * RFC 실행후 Export 값을 Vector 로 Return 한다.     * 반드시 com.sns.jdf.SAPWrap.excute(JCO.Client mConnection, JCO.Function function) 가 호출된후에 실행되어야하는 메소드     * @param function com.sap.mw.jco.JCO.Function     * @return java.util.Vector     * @exception com.sns.jdf.GeneralException     */    private Vector getOutput(JCO.Function function) throws GeneralException {        String entityName = "hris.common.PdfParseData";        String tableName  = "T_RESULT";        return getTable(entityName, function, tableName);    }}