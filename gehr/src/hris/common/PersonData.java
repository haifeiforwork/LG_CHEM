package hris.common;

/**
 * PersonData.java
 *  전화번호 정보
 *   [관련 RFC] : ZHRW_RFC_GET_PHONE_NUM
 *
 * @author 김성일
 * @version 1.0, 2001/12/13
 * 						C20140416_24713 경조금신청시주문자정보추가
 */
public class PersonData extends com.sns.jdf.EntityData {

    public String 	E_MOLGA	;//	CHAR	2	국가 그루핑		공통 추가
    public String 	E_PERNR	;//	NUMC	8	사원 번호
    public String 	E_ENAME	;//	CHAR	40	성명
    public String 	E_BUKRS	;//	CHAR	4	회사 코드
    public String 	E_WERKS	;//	CHAR	4	인사 영역
    public String 	E_BTRTL	;//	CHAR	4	인사 하위 영역
    public String 	E_ORGEH	;//	NUMC	8	조직 단위
    public String 	E_ORGTX	;//	CHAR	40	소속명
    public String 	E_PERSG	;//	CHAR	 1 	사원 그룹
    public String 	E_PERSK	;//	CHAR	 2 	사원 하위 그룹
    public String 	E_OBJID	;//	NUMC	 8 	조직 단위
    public String 	E_OBJTX	;//	CHAR	 40 	소속명
    public String 	E_DAT02	;//	DATS	 8 	회사입사일		국내(DAT03)
    public String 	E_PHONE_NUM	;//	CHAR	 20 	담당자의 전화번호
    public String 	E_CELL_PHONE	;//	CHAR	 20 	담당자의 전화번호
    public String 	E_MAIL	;//	CHAR	 241 	전자메일 주소
    public String 	E_TIMEADMIN	;//	CHAR	 1 	부서근태 대리신청자여부		국내전용
    public String 	E_REPRESENTATIVE	;//	CHAR	 1 	대리신청자여부
    public String 	E_AUTHORIZATION	;//	CHAR	 10 	권한조합
    public String 	E_AUTHORIZATION2	;//	CHAR	 10 	권한조합(특수)
    public String 	E_DEPTC	;//	CHAR	 1 	관리자='Y'
    public String 	E_RETIR	;//	CHAR	 1 	퇴직자 조회 여부(조회가능='Y')
    public String 	E_REDAY	;//	DATS	 8 	퇴직일자
    public String 	E_IS_CHIEF	;//	CHAR	 1 	간사여부 플래그('Y':간사, 'N':비간사)		국내전용
    public String 	E_GANSA	;//	CHAR	 1 	FLAG(X=간사아님 Y=간사)		국내전용
    public String 	E_OVERSEA	;//	CHAR	 1 	FLAG 여부('X':true, ' ':false, 'L':복귀자)		국내전용
    public String 	E_RECON	;//	CHAR	 1 	퇴직구분('D'-사망'S'-미혼'Y'-퇴직)		국내전용
    public String 	E_GBDAT	;//	DATS	 8 	생년월일		국내전용
    public String 	E_GRUP_NUMB	;//	CHAR	 2 	사업장		국내전용
    public String 	E_JIKWE	;//	CHAR	 20 	직위
    public String 	E_JIKWT	;//	CHAR	 40 	직위명		국내(TITEL)
    public String 	E_JIKKB	;//	CHAR	 20 	직책
    public String 	E_JIKKT	;//	CHAR	 40 	직책명		국내(TITL2)
    public String 	E_REGNO	;//	CHAR	 13 	주민등록번호 (한국)		국내전용
    public String 	E_TRFAR	;//	CHAR	 2 	호봉 유형		국내전용
    public String 	E_TRFGR	;//	CHAR	 8 	호봉 그룹		국내전용
    public String 	E_TRFST	;//	CHAR	 2 	호봉 단계		국내전용
    public String 	E_VGLGR	;//	CHAR	 8 	두번째 급여요소의 호봉그룹		국내전용
    public String 	E_VGLST	;//	CHAR	 2 	2번째 급여요소에 대한 호봉		국내전용
    public String 	E_STRAS	;//	CHAR	 60 	상세 주소 및 번지		국내전용
    public String 	E_LOCAT	;//	CHAR	 40 	두번째 주소라인		국내전용
    public String 	E_JIKCH	;//	CHAR	 20 	직급
    public String 	E_JIKCT	;//	CHAR	 40 	직급명
    public String 	E_EXPIR	;//	CHAR	 1 	Expiry flag		해외특화
    public String  E_PTEXT;
    public String  E_BTEXT; // 인사 하위 영역 텍스트

    public String getE_ENAME() {
		return E_ENAME;
	}

	public void setE_ENAME(String e_ENAME) {
		E_ENAME = e_ENAME;
	}

	public String getE_BUKRS() {
		return E_BUKRS;
	}

	public void setE_BUKRS(String e_BUKRS) {
		E_BUKRS = e_BUKRS;
	}

	public String getE_BTRTL() {
		return E_BTRTL;
	}

	public void setE_BTRTL(String e_BTRTL) {
		E_BTRTL = e_BTRTL;
	}

	public String getE_ORGEH() {
		return E_ORGEH;
	}

	public void setE_ORGEH(String e_ORGEH) {
		E_ORGEH = e_ORGEH;
	}

	public String getE_PERSG() {
		return E_PERSG;
	}

	public void setE_PERSG(String e_PERSG) {
		E_PERSG = e_PERSG;
	}

	public String getE_OBJID() {
		return E_OBJID;
	}

	public void setE_OBJID(String e_OBJID) {
		E_OBJID = e_OBJID;
	}

	public String getE_OBJTX() {
		return E_OBJTX;
	}

	public void setE_OBJTX(String e_OBJTX) {
		E_OBJTX = e_OBJTX;
	}

	public String getE_DAT02() {
		return E_DAT02;
	}

	public void setE_DAT02(String e_DAT02) {
		E_DAT02 = e_DAT02;
	}

	public String getE_PHONE_NUM() {
		return E_PHONE_NUM;
	}

	public void setE_PHONE_NUM(String e_PHONE_NUM) {
		E_PHONE_NUM = e_PHONE_NUM;
	}

	public String getE_CELL_PHONE() {
		return E_CELL_PHONE;
	}

	public void setE_CELL_PHONE(String e_CELL_PHONE) {
		E_CELL_PHONE = e_CELL_PHONE;
	}

	public String getE_MAIL() {
		return E_MAIL;
	}

	public void setE_MAIL(String e_MAIL) {
		E_MAIL = e_MAIL;
	}

	public String getE_TIMEADMIN() {
		return E_TIMEADMIN;
	}

	public void setE_TIMEADMIN(String e_TIMEADMIN) {
		E_TIMEADMIN = e_TIMEADMIN;
	}

	public String getE_REPRESENTATIVE() {
		return E_REPRESENTATIVE;
	}

	public void setE_REPRESENTATIVE(String e_REPRESENTATIVE) {
		E_REPRESENTATIVE = e_REPRESENTATIVE;
	}

	public String getE_AUTHORIZATION() {
		return E_AUTHORIZATION;
	}

	public void setE_AUTHORIZATION(String e_AUTHORIZATION) {
		E_AUTHORIZATION = e_AUTHORIZATION;
	}

	public String getE_AUTHORIZATION2() {
		return E_AUTHORIZATION2;
	}

	public void setE_AUTHORIZATION2(String e_AUTHORIZATION2) {
		E_AUTHORIZATION2 = e_AUTHORIZATION2;
	}

	public String getE_DEPTC() {
		return E_DEPTC;
	}

	public void setE_DEPTC(String e_DEPTC) {
		E_DEPTC = e_DEPTC;
	}

	public String getE_RETIR() {
		return E_RETIR;
	}

	public void setE_RETIR(String e_RETIR) {
		E_RETIR = e_RETIR;
	}

	public String getE_REDAY() {
		return E_REDAY;
	}

	public void setE_REDAY(String e_REDAY) {
		E_REDAY = e_REDAY;
	}

	public String getE_IS_CHIEF() {
		return E_IS_CHIEF;
	}

	public void setE_IS_CHIEF(String e_IS_CHIEF) {
		E_IS_CHIEF = e_IS_CHIEF;
	}

	public String getE_GANSA() {
		return E_GANSA;
	}

	public void setE_GANSA(String e_GANSA) {
		E_GANSA = e_GANSA;
	}

	public String getE_OVERSEA() {
		return E_OVERSEA;
	}

	public void setE_OVERSEA(String e_OVERSEA) {
		E_OVERSEA = e_OVERSEA;
	}

	public String getE_RECON() {
		return E_RECON;
	}

	public void setE_RECON(String e_RECON) {
		E_RECON = e_RECON;
	}

	public String getE_GBDAT() {
		return E_GBDAT;
	}

	public void setE_GBDAT(String e_GBDAT) {
		E_GBDAT = e_GBDAT;
	}

	public String getE_GRUP_NUMB() {
		return E_GRUP_NUMB;
	}

	public void setE_GRUP_NUMB(String e_GRUP_NUMB) {
		E_GRUP_NUMB = e_GRUP_NUMB;
	}

	public String getE_JIKWE() {
		return E_JIKWE;
	}

	public void setE_JIKWE(String e_JIKWE) {
		E_JIKWE = e_JIKWE;
	}

	public String getE_JIKKB() {
		return E_JIKKB;
	}

	public void setE_JIKKB(String e_JIKKB) {
		E_JIKKB = e_JIKKB;
	}

	public String getE_JIKKT() {
		return E_JIKKT;
	}

	public void setE_JIKKT(String e_JIKKT) {
		E_JIKKT = e_JIKKT;
	}

	public String getE_REGNO() {
		return E_REGNO;
	}

	public void setE_REGNO(String e_REGNO) {
		E_REGNO = e_REGNO;
	}

	public String getE_TRFAR() {
		return E_TRFAR;
	}

	public void setE_TRFAR(String e_TRFAR) {
		E_TRFAR = e_TRFAR;
	}

	public String getE_TRFGR() {
		return E_TRFGR;
	}

	public void setE_TRFGR(String e_TRFGR) {
		E_TRFGR = e_TRFGR;
	}

	public String getE_TRFST() {
		return E_TRFST;
	}

	public void setE_TRFST(String e_TRFST) {
		E_TRFST = e_TRFST;
	}

	public String getE_VGLGR() {
		return E_VGLGR;
	}

	public void setE_VGLGR(String e_VGLGR) {
		E_VGLGR = e_VGLGR;
	}

	public String getE_VGLST() {
		return E_VGLST;
	}

	public void setE_VGLST(String e_VGLST) {
		E_VGLST = e_VGLST;
	}

	public String getE_STRAS() {
		return E_STRAS;
	}

	public void setE_STRAS(String e_STRAS) {
		E_STRAS = e_STRAS;
	}

	public String getE_LOCAT() {
		return E_LOCAT;
	}

	public void setE_LOCAT(String e_LOCAT) {
		E_LOCAT = e_LOCAT;
	}

	public String getE_JIKCH() {
		return E_JIKCH;
	}

	public void setE_JIKCH(String e_JIKCH) {
		E_JIKCH = e_JIKCH;
	}

	public String getE_JIKCT() {
		return E_JIKCT;
	}

	public void setE_JIKCT(String e_JIKCT) {
		E_JIKCT = e_JIKCT;
	}

	public String getE_EXPIR() {
		return E_EXPIR;
	}

	public void setE_EXPIR(String e_EXPIR) {
		E_EXPIR = e_EXPIR;
	}

	public String getE_PTEXT() {
		return E_PTEXT;
	}

	public void setE_PTEXT(String e_PTEXT) {
		E_PTEXT = e_PTEXT;
	}

	public String getE_BTEXT() {
		return E_BTEXT;
	}

	public void setE_BTEXT(String e_BTEXT) {
		E_BTEXT = e_BTEXT;
	}

	public void setE_MOLGA(String e_MOLGA) {
		E_MOLGA = e_MOLGA;
	}

	public void setE_PERNR(String e_PERNR) {
		E_PERNR = e_PERNR;
	}

	public void setE_WERKS(String e_WERKS) {
		E_WERKS = e_WERKS;
	}

	public void setE_ORGTX(String e_ORGTX) {
		E_ORGTX = e_ORGTX;
	}

	public void setE_PERSK(String e_PERSK) {
		E_PERSK = e_PERSK;
	}

	public void setE_JIKWT(String e_JIKWT) {
		E_JIKWT = e_JIKWT;
	}

	public String gete_MOLGA() {
        return E_MOLGA;
    }

    public String getE_MOLGA() {
        return E_MOLGA;
    }

    public void sete_MOLGA(String e_MOLGA) {
        E_MOLGA = e_MOLGA;
    }

    public String getE_PERNR() {
        return E_PERNR;
    }

    public String gete_PERNR() {
        return E_PERNR;
    }

    public void sete_PERNR(String e_PERNR) {
        E_PERNR = e_PERNR;
    }

    public String gete_ENAME() {
        return E_ENAME;
    }

    public void sete_ENAME(String e_ENAME) {
        E_ENAME = e_ENAME;
    }

    public String gete_BUKRS() {
        return E_BUKRS;
    }

    public void sete_BUKRS(String e_BUKRS) {
        E_BUKRS = e_BUKRS;
    }

    public String gete_WERKS() {
        return E_WERKS;
    }

    public void sete_WERKS(String e_WERKS) {
        E_WERKS = e_WERKS;
    }

    public String gete_BTRTL() {
        return E_BTRTL;
    }

    public void sete_BTRTL(String e_BTRTL) {
        E_BTRTL = e_BTRTL;
    }

    public String gete_ORGEH() {
        return E_ORGEH;
    }

    public void sete_ORGEH(String e_ORGEH) {
        E_ORGEH = e_ORGEH;
    }

    public String getE_ORGTX() {
        return E_ORGTX;
    }

    public String gete_ORGTX() {
        return E_ORGTX;
    }
    public void sete_ORGTX(String e_ORGTX) {
        E_ORGTX = e_ORGTX;
    }

    public String gete_PERSG() {
        return E_PERSG;
    }

    public void sete_PERSG(String e_PERSG) {
        E_PERSG = e_PERSG;
    }

    public String gete_PERSK() {
        return E_PERSK;
    }

    public void sete_PERSK(String e_PERSK) {
        E_PERSK = e_PERSK;
    }

    public String gete_OBJID() {
        return E_OBJID;
    }

    public void sete_OBJID(String e_OBJID) {
        E_OBJID = e_OBJID;
    }

    public String gete_OBJTX() {
        return E_OBJTX;
    }

    public void sete_OBJTX(String e_OBJTX) {
        E_OBJTX = e_OBJTX;
    }

    public String gete_DAT02() {
        return E_DAT02;
    }

    public void sete_DAT02(String e_DAT02) {
        E_DAT02 = e_DAT02;
    }

    public String gete_PHONE_NUM() {
        return E_PHONE_NUM;
    }

    public void sete_PHONE_NUM(String e_PHONE_NUM) {
        E_PHONE_NUM = e_PHONE_NUM;
    }

    public String gete_CELL_PHONE() {
        return E_CELL_PHONE;
    }

    public void sete_CELL_PHONE(String e_CELL_PHONE) {
        E_CELL_PHONE = e_CELL_PHONE;
    }

    public String gete_MAIL() {
        return E_MAIL;
    }

    public void sete_MAIL(String e_MAIL) {
        E_MAIL = e_MAIL;
    }

    public String gete_TIMEADMIN() {
        return E_TIMEADMIN;
    }

    public void sete_TIMEADMIN(String e_TIMEADMIN) {
        E_TIMEADMIN = e_TIMEADMIN;
    }

    public String gete_REPRESENTATIVE() {
        return E_REPRESENTATIVE;
    }

    public void sete_REPRESENTATIVE(String e_REPRESENTATIVE) {
        E_REPRESENTATIVE = e_REPRESENTATIVE;
    }

    public String gete_AUTHORIZATION() {
        return E_AUTHORIZATION;
    }

    public void sete_AUTHORIZATION(String e_AUTHORIZATION) {
        E_AUTHORIZATION = e_AUTHORIZATION;
    }

    public String gete_AUTHORIZATION2() {
        return E_AUTHORIZATION2;
    }

    public void sete_AUTHORIZATION2(String e_AUTHORIZATION2) {
        E_AUTHORIZATION2 = e_AUTHORIZATION2;
    }

    public String gete_DEPTC() {
        return E_DEPTC;
    }

    public void sete_DEPTC(String e_DEPTC) {
        E_DEPTC = e_DEPTC;
    }

    public String gete_RETIR() {
        return E_RETIR;
    }

    public void sete_RETIR(String e_RETIR) {
        E_RETIR = e_RETIR;
    }

    public String gete_REDAY() {
        return E_REDAY;
    }

    public void sete_REDAY(String e_REDAY) {
        E_REDAY = e_REDAY;
    }

    public String gete_IS_CHIEF() {
        return E_IS_CHIEF;
    }

    public void sete_IS_CHIEF(String e_IS_CHIEF) {
        E_IS_CHIEF = e_IS_CHIEF;
    }

    public String gete_GANSA() {
        return E_GANSA;
    }

    public void sete_GANSA(String e_GANSA) {
        E_GANSA = e_GANSA;
    }

    public String gete_OVERSEA() {
        return E_OVERSEA;
    }

    public void sete_OVERSEA(String e_OVERSEA) {
        E_OVERSEA = e_OVERSEA;
    }

    public String gete_RECON() {
        return E_RECON;
    }

    public void sete_RECON(String e_RECON) {
        E_RECON = e_RECON;
    }

    public String gete_GBDAT() {
        return E_GBDAT;
    }

    public void sete_GBDAT(String e_GBDAT) {
        E_GBDAT = e_GBDAT;
    }

    public String gete_GRUP_NUMB() {
        return E_GRUP_NUMB;
    }

    public void sete_GRUP_NUMB(String e_GRUP_NUMB) {
        E_GRUP_NUMB = e_GRUP_NUMB;
    }

    public String gete_JIKWE() {
        return E_JIKWE;
    }

    public void sete_JIKWE(String e_JIKWE) {
        E_JIKWE = e_JIKWE;
    }

    public String gete_JIKWT() {
        return E_JIKWT;
    }

    public String getE_JIKWT() {
        return E_JIKWT;
    }
    public void sete_JIKWT(String e_JIKWT) {
        E_JIKWT = e_JIKWT;
    }

    public String gete_JIKKB() {
        return E_JIKKB;
    }

    public void sete_JIKKB(String e_JIKKB) {
        E_JIKKB = e_JIKKB;
    }

    public String gete_JIKKT() {
        return E_JIKKT;
    }

    public void sete_JIKKT(String e_JIKKT) {
        E_JIKKT = e_JIKKT;
    }

    public String gete_REGNO() {
        return E_REGNO;
    }

    public void sete_REGNO(String e_REGNO) {
        E_REGNO = e_REGNO;
    }

    public String gete_TRFAR() {
        return E_TRFAR;
    }

    public void sete_TRFAR(String e_TRFAR) {
        E_TRFAR = e_TRFAR;
    }

    public String gete_TRFGR() {
        return E_TRFGR;
    }

    public void sete_TRFGR(String e_TRFGR) {
        E_TRFGR = e_TRFGR;
    }

    public String gete_TRFST() {
        return E_TRFST;
    }

    public void sete_TRFST(String e_TRFST) {
        E_TRFST = e_TRFST;
    }

    public String gete_VGLGR() {
        return E_VGLGR;
    }

    public void sete_VGLGR(String e_VGLGR) {
        E_VGLGR = e_VGLGR;
    }

    public String gete_VGLST() {
        return E_VGLST;
    }

    public void sete_VGLST(String e_VGLST) {
        E_VGLST = e_VGLST;
    }

    public String gete_STRAS() {
        return E_STRAS;
    }

    public void sete_STRAS(String e_STRAS) {
        E_STRAS = e_STRAS;
    }

    public String gete_LOCAT() {
        return E_LOCAT;
    }

    public void sete_LOCAT(String e_LOCAT) {
        E_LOCAT = e_LOCAT;
    }

    public String gete_JIKCH() {
        return E_JIKCH;
    }

    public void sete_JIKCH(String e_JIKCH) {
        E_JIKCH = e_JIKCH;
    }

    public String gete_JIKCT() {
        return E_JIKCT;
    }

    public void sete_JIKCT(String e_JIKCT) {
        E_JIKCT = e_JIKCT;
    }

    public String gete_EXPIR() {
        return E_EXPIR;
    }

    public void sete_EXPIR(String e_EXPIR) {
        E_EXPIR = e_EXPIR;
    }

    public String gete_PTEXT() {
        return E_PTEXT;
    }

    public void sete_PTEXT(String e_PTEXT) {
        E_PTEXT = e_PTEXT;
    }



    public String gete_BTEXT() {
		return E_BTEXT;
	}

	public void sete_BTEXT(String e_BTEXT) {
		E_BTEXT = e_BTEXT;
	}

	public String getE_WERKS() {
        return E_WERKS;
    }

    public String getE_PERSK() {
        return E_PERSK;
    }
}
