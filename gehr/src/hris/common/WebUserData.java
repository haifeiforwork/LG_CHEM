package hris.common;

import com.common.constant.Area;
import com.sns.jdf.sap.SAPType;
import org.apache.commons.lang.math.NumberUtils;

import java.util.Locale;

/**
 * WebUserData.java
 *  로그인시에 가져온 데이터와 DB 데이터
 *  ZGHR_RFC_PERSON_SINFO
 *
 * @author 김성일
 * @version 1.0, 2001/12/14
 */
/**
 * @author eunhakim
 *@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel 
 */
public class WebUserData extends com.sns.jdf.EntityData {

    public String login_stat  ;    // 로그인 상태
    public String webUserId   ;    // 아이디
    public String webUserPwd  ;    // 비밀번호
    public String empNo       ;    // 사번
    public String companyCode ;    // 회사코드
    public String clientNo    ;    // R3 client Number
    public String ename       ;    // 이름
    public String e_titel     ;    // 직책
    public String e_titl2     ;    // 직책 2
    public String e_orgtx     ;    // 조직단위 텍스트
    public String e_is_chief  ;    // 인포멀 간사 여부(간사:Y,비간사:N)
    public String e_stras     ;    // 주소1
    public String e_locat     ;    // 나머지 주소
    public String e_regno     ;    // 주민등록번호( - 포함안함)
    public String e_oversea   ;    // 해외근무자면 "X" , 국내근무자면 "",복귀자면 "L"
    public String e_phone_num ;    // 개인 전화번호
    public String e_cell_phone;    // 개인 휴대폰번호
    public String e_trfar     ;    // 급여유형
    public String e_trfgr     ;    // 급여그룹
    public String e_trfst     ;    // 급여레벨
    public String e_vglgr     ;    // 두번째 급여요소의 급여범위/직급
    public String e_vglst     ;    // 두번째급여요소 호봉
    public String e_dat03     ;    // 입사일
    public String e_persk     ;    // 사원서브그룹

    //  부서원검색 메뉴를 추가하면서 상위 관리자의 사번을 저장하기 위해 추가
    public String e_deptc     ;    //e_deptc='Y'이면 부서원검색 메뉴를 display한다.
    public String e_retir     ;    //e_retir='Y'이면 퇴직자 조회가 가능하다.
    public String i_dept      ;    //상위 관리자의 사번
    public String i_stat2     ;    //재직자,퇴직자 구분

    //  인사담당자 연락처 검색을 위한 해당사원의 사업장
    public String e_grup_numb ;    //해당사원의 사업장 정보

    //  e-learning 시스템과 인터페이스를 하기 위한 구분 값
    public String e_learning  ;    //"Y"이면 e-learning 시스템으로부터의 연결로 본다.
    public String OBJID       ;    //e-learning 시스템에서 관리하는 objid

    public String e_gansa     ;
    // 결재 관련 필드 추가
    public String user_group  ;    // 메뉴 접근 권한 그룹
    public String SSNO        ;    // ElOffice에 준 암호화 사번
    public String SServer     ;    // ElOffice에 접속한 서버 주소
    public String e_orgeh     ;      // 조직코드
    public String e_representative;  // 대리신청
    public String e_authorization;   // 권한조합
    public String e_authorization2; // 권한조합2 20141125 [CSR ID:2651528] 인사권한 추가 및 메뉴조회 기능 변경
    public String e_timeadmin;   // 부서근태 대리신청자여부 09.06.22

    // 로그인 정보 체크
    public String loginPlace  ;

    public String e_objid     ;    // s-o 조직코드
    public String e_obtxt     ;    // s-o 조직명
    public String e_werks     ;    // 인사영역(EC00 이면 해외법인)
    public String e_recon     ;    // 퇴직구분('D'-사망'S'-미혼'Y'-퇴직)
    public String e_reday     ;    // 퇴직일자
    public String e_mail      ;    // e_mail
    public String returnUrl   ;    // ep의 returnUrl
    public String e_btrtl     ;    // 인사하위영역 [CSR ID:3004032]

    public Locale locale		;	//접속 Locale 값 - 언어처리
    public SAPType sapType		;	//기본 접속 대상 RFC 값 - 국내, 해외 SAP 연결정보
    public Area area;       //국가 정보

    public String e_area;  //해외

    public String remoteIP;

    public String e_mss;

    public String e_jikkb;

    public String getE_jikkb() {
		return e_jikkb;
	}

	public void setE_jikkb(String e_jikkb) {
		this.e_jikkb = e_jikkb;
	}



	public int getIpersk() {
        try {
            return NumberUtils.toInt(e_persk);
        } catch(Exception e) {

        }
        return -1;
    }

	//@PJ.멕시코 법인 Rollout 프로젝트 추가 관련(Area = MX("32")) 2018/02/09 rdcamel 
	public boolean isEurp() {
        return area == Area.DE || area == Area.PL || area == Area.US || area == Area.MX;
    }

    public String getLogin_stat() {
        return login_stat;
    }

    public void setLogin_stat(String login_stat) {
        this.login_stat = login_stat;
    }

    public String getWebUserId() {
        return webUserId;
    }

    public void setWebUserId(String webUserId) {
        this.webUserId = webUserId;
    }

    public String getWebUserPwd() {
        return webUserPwd;
    }

    public void setWebUserPwd(String webUserPwd) {
        this.webUserPwd = webUserPwd;
    }

    public String getEmpNo() {
        return empNo;
    }

    public void setEmpNo(String empNo) {
        this.empNo = empNo;
    }

    public String getCompanyCode() {
        return companyCode;
    }

    public void setCompanyCode(String companyCode) {
        this.companyCode = companyCode;
    }

    public String getClientNo() {
        return clientNo;
    }

    public void setClientNo(String clientNo) {
        this.clientNo = clientNo;
    }

    public String getEname() {
        return ename;
    }

    public void setEname(String ename) {
        this.ename = ename;
    }

    public String getE_titel() {
        return e_titel;
    }

    public void setE_titel(String e_titel) {
        this.e_titel = e_titel;
    }

    public String getE_titl2() {
        return e_titl2;
    }

    public void setE_titl2(String e_titl2) {
        this.e_titl2 = e_titl2;
    }

    public String getE_orgtx() {
        return e_orgtx;
    }

    public void setE_orgtx(String e_orgtx) {
        this.e_orgtx = e_orgtx;
    }

    public String getE_is_chief() {
        return e_is_chief;
    }

    public void setE_is_chief(String e_is_chief) {
        this.e_is_chief = e_is_chief;
    }

    public String getE_stras() {
        return e_stras;
    }

    public void setE_stras(String e_stras) {
        this.e_stras = e_stras;
    }

    public String getE_locat() {
        return e_locat;
    }

    public void setE_locat(String e_locat) {
        this.e_locat = e_locat;
    }

    public String getE_regno() {
        return e_regno;
    }

    public void setE_regno(String e_regno) {
        this.e_regno = e_regno;
    }

    public String getE_oversea() {
        return e_oversea;
    }

    public void setE_oversea(String e_oversea) {
        this.e_oversea = e_oversea;
    }

    public String getE_phone_num() {
        return e_phone_num;
    }

    public void setE_phone_num(String e_phone_num) {
        this.e_phone_num = e_phone_num;
    }

    public String getE_cell_phone() {
        return e_cell_phone;
    }

    public void setE_cell_phone(String e_cell_phone) {
        this.e_cell_phone = e_cell_phone;
    }

    public String getE_trfar() {
        return e_trfar;
    }

    public void setE_trfar(String e_trfar) {
        this.e_trfar = e_trfar;
    }

    public String getE_trfgr() {
        return e_trfgr;
    }

    public void setE_trfgr(String e_trfgr) {
        this.e_trfgr = e_trfgr;
    }

    public String getE_trfst() {
        return e_trfst;
    }

    public void setE_trfst(String e_trfst) {
        this.e_trfst = e_trfst;
    }

    public String getE_vglgr() {
        return e_vglgr;
    }

    public void setE_vglgr(String e_vglgr) {
        this.e_vglgr = e_vglgr;
    }

    public String getE_vglst() {
        return e_vglst;
    }

    public void setE_vglst(String e_vglst) {
        this.e_vglst = e_vglst;
    }

    public String getE_dat03() {
        return e_dat03;
    }

    public void setE_dat03(String e_dat03) {
        this.e_dat03 = e_dat03;
    }

    public String getE_persk() {
        return e_persk;
    }

    public void setE_persk(String e_persk) {
        this.e_persk = e_persk;
    }

    public String getE_deptc() {
        return e_deptc;
    }

    public void setE_deptc(String e_deptc) {
        this.e_deptc = e_deptc;
    }

    public String getE_retir() {
        return e_retir;
    }

    public void setE_retir(String e_retir) {
        this.e_retir = e_retir;
    }

    public String getI_dept() {
        return i_dept;
    }

    public void setI_dept(String i_dept) {
        this.i_dept = i_dept;
    }

    public String getI_stat2() {
        return i_stat2;
    }

    public void setI_stat2(String i_stat2) {
        this.i_stat2 = i_stat2;
    }

    public String getE_grup_numb() {
        return e_grup_numb;
    }

    public void setE_grup_numb(String e_grup_numb) {
        this.e_grup_numb = e_grup_numb;
    }

    public String getE_learning() {
        return e_learning;
    }

    public void setE_learning(String e_learning) {
        this.e_learning = e_learning;
    }

    public String getOBJID() {
        return OBJID;
    }

    public void setOBJID(String OBJID) {
        this.OBJID = OBJID;
    }

    public String getE_gansa() {
        return e_gansa;
    }

    public void setE_gansa(String e_gansa) {
        this.e_gansa = e_gansa;
    }

    public String getUser_group() {
        return user_group;
    }

    public void setUser_group(String user_group) {
        this.user_group = user_group;
    }

    public String getSSNO() {
        return SSNO;
    }

    public void setSSNO(String SSNO) {
        this.SSNO = SSNO;
    }

    public String getSServer() {
        return SServer;
    }

    public void setSServer(String SServer) {
        this.SServer = SServer;
    }

    public String getE_orgeh() {
        return e_orgeh;
    }

    public void setE_orgeh(String e_orgeh) {
        this.e_orgeh = e_orgeh;
    }

    public String getE_representative() {
        return e_representative;
    }

    public void setE_representative(String e_representative) {
        this.e_representative = e_representative;
    }

    public String getE_authorization() {
        return e_authorization;
    }

    public void setE_authorization(String e_authorization) {
        this.e_authorization = e_authorization;
    }

    public String getE_authorization2() {
        return e_authorization2;
    }

    public void setE_authorization2(String e_authorization2) {
        this.e_authorization2 = e_authorization2;
    }

    public String getE_timeadmin() {
        return e_timeadmin;
    }

    public void setE_timeadmin(String e_timeadmin) {
        this.e_timeadmin = e_timeadmin;
    }

    public String getLoginPlace() {
        return loginPlace;
    }

    public void setLoginPlace(String loginPlace) {
        this.loginPlace = loginPlace;
    }

    public String getE_objid() {
        return e_objid;
    }

    public void setE_objid(String e_objid) {
        this.e_objid = e_objid;
    }

    public String getE_obtxt() {
        return e_obtxt;
    }

    public void setE_obtxt(String e_obtxt) {
        this.e_obtxt = e_obtxt;
    }

    public String getE_werks() {
        return e_werks;
    }

    public void setE_werks(String e_werks) {
        this.e_werks = e_werks;
    }

    public String getE_recon() {
        return e_recon;
    }

    public void setE_recon(String e_recon) {
        this.e_recon = e_recon;
    }

    public String getE_reday() {
        return e_reday;
    }

    public void setE_reday(String e_reday) {
        this.e_reday = e_reday;
    }

    public String getE_mail() {
        return e_mail;
    }

    public void setE_mail(String e_mail) {
        this.e_mail = e_mail;
    }

    public String getReturnUrl() {
        return returnUrl;
    }

    public void setReturnUrl(String returnUrl) {
        this.returnUrl = returnUrl;
    }

    public String getE_btrtl() {
        return e_btrtl;
    }

    public void setE_btrtl(String e_btrtl) {
        this.e_btrtl = e_btrtl;
    }

    public Locale getLocale() {
        return locale;
    }

    public void setLocale(Locale locale) {
        this.locale = locale;
    }

    public SAPType getSapType() {
        return sapType;
    }

    public void setSapType(SAPType sapType) {
        this.sapType = sapType;
    }

    public Area getArea() {
        return area;
    }

    public void setArea(Area area) {
        this.area = area;
    }

    public String getE_area() {
        return e_area;
    }

    public void setE_area(String e_area) {
        this.e_area = e_area;
    }

    public String getRemoteIP() {
        return remoteIP;
    }

    public void setRemoteIP(String remoteIP) {
        this.remoteIP = remoteIP;
    }

    public String getE_mss() {
		return e_mss;
	}

	public void setE_mss(String e_mss) {
		this.e_mss = e_mss;
	}
}
