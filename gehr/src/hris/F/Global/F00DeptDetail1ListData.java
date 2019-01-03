/******************************************************************************/
/*   System Name  	: g-HR
/*   1Depth Name  	: Organization & Staffing
/*   2Depth Name  	: Headcount
/*   Program Name 	: Org.Unit/Level (Staff Present State Detail)
/*   Program ID   		: F00DeptDetail1ListData.java
/*   Description  		: 인원현황 각각의 상세화면
/*   Note         		: 없음
/*   Creation     		: 2005-03-07 유용원
/*   Update				: 2008-01-21 jungin @v1.0 ORGTX_SP, POSIX_SP 추가.
/*   						: 2008-01-29 jungin @v1.1 HPI_DATE 추가.
/*   						: 2008-02-15 jungin @v1.2 POSIX, PTEXT 추가.
/******************************************************************************/

package hris.F.Global;

/**
 * F00DeptDetailListData
 *  인원현황 각각의 상세화면 내용을 담는 데이터
 *
 * @author 유용원
 * @version 1.0,
 */
public class F00DeptDetail1ListData extends com.sns.jdf.EntityData {
	public String PBTXT     	;    	//사번
    public String PERNR     		;    	//사번
    public String ENAME     	;    	//성명
    public String ORGEH     	;    	//소속텍스트
    public String ORGTX     	;    	//소속약어
    public String JIKKB     		;    	//직위
    public String JIKKT     		;    	//직위
    public String JIKWE     		;    	//직위
    public String JIKWT     		;    	//직위
    public String JIKCH     		;    	//직위
    public String JIKCT     		;    	//직위
    public String ANNUL     	;
    public String JIKCT_ANN 	;
    public String STELL     		;
    public String STLTX     	;
    public String DAT01     	;
    public String GUNSOK    	;
    public String OLDS      		;
    public String UNIV_TXT  	;
    public String UNIV_BR   	;
    public String UNIV   	    	;     // add by liukuo 2010.12.01
    public String MAST_TXT  	;
    public String MAST_BR   	;
    public String MAST   	    ;      // add by liukuo 2010.12.01
    public String CET       		;
    public String TOEIC     		;
    public String JLPT      		;
    public String NSS       		;
    public String KPT       		;
    public String RTEXT1       ;
    public String RTEXT2       ;
    public String RTEXT3       ;

    public String ORGTX_SP	;		//SP-Org.Unit
    public String POSIX_SP		;		//SP-Position
    public String HPI_DATE		;		//HPI-Start Date
    public String POSIX			;		//Position
    public String PTEXT			;		//Emp.Subgroup

}
