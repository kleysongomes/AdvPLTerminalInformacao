/*
    Esse exemplo faz parte da s�rie do YouTube, Maratona de Exemplos, do canal Terminal de Informa��o, 
    caso queira ver esse exemplo rodando em v�deo, acesse o seguinte link:     https://terminaldeinformacao.com/2024/06/11/exibindo-imagens-atraves-da-tbitmap-maratona-advpl-e-tl-470/
*/


//Bibliotecas
#Include "Totvs.ch"
#Include "TopConn.ch"
#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"

//Alinhamentos
#Define PAD_LEFT    0
#Define PAD_RIGHT   1
#Define PAD_CENTER  2

//Cor(es)
Static nCorCinza := RGB(110, 110, 110)
Static nCorLinha := RGB(148, 255, 180)

/*/{Protheus.doc} User Function zExe471
Classe para criar um pincel (geralmente para usar em relat�rios)
@type Function
@author Atilio
@since 03/04/2023
@see https://tdn.totvs.com/display/tec/TBrush
@obs 

    **** Apoie nosso projeto, se inscreva em https://www.youtube.com/TerminalDeInformacao ****
/*/

User Function zExe471()
	Local aArea := FWGetArea()
	Local aPergs   := {}
	Local xPar0 := Space(15)
	Local xPar1 := Space(15)
	
	//Adicionando os parametros do ParamBox
	aAdd(aPergs, {1, "Produto De", xPar0,  "", ".T.", "SB1", ".T.", 80,  .F.})
	aAdd(aPergs, {1, "Produto At�", xPar1,  "", ".T.", "SB1", ".T.", 80,  .T.})
	
	//Se a pergunta for confirma, cria o relatorio
	If ParamBox(aPergs, "Informe os parametros")
		Processa({|| fImprime()})
	EndIf
	
	FWRestArea(aArea)
Return

/*/{Protheus.doc} fImprime
Faz a impress�o do relat�rio zExe236
@author Atilio
@since 20/02/2023
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
@see http://autumncodemaker.com
/*/

Static Function fImprime()
    Local aArea        := GetArea()
    Local nTotAux      := 0
    Local nAtuAux      := 0
    Local cQryAux      := ''
    Local cArquivo     := 'zExe236'+RetCodUsr()+'_' + dToS(Date()) + '_' + StrTran(Time(), ':', '-') + '.pdf'
    Private oPrintPvt
    Private oBrushLin  := TBrush():New(,nCorLinha)
    Private cHoraEx    := Time()
    Private nPagAtu    := 1
    Private cLogoEmp   := fLogoEmp()
    //Linhas e colunas
    Private nLinAtu    := 0
    Private nLinFin    := 800
    Private nColIni    := 010
    Private nColFin    := 580
    Private nColMeio   := (nColFin-nColIni)/2
    //Colunas dos relatorio
    Private nColDad1    := nColIni
    Private nColDad2    := nColIni + 50
    Private nColDad3    := nColIni + 150
    Private nColDad4    := nColIni + 200
    Private nColDad5    := nColIni + 300
    //Declarando as fontes
    Private cNomeFont  := 'Arial'
    Private oFontDet   := TFont():New(cNomeFont, 9, -11, .T., .F., 5, .T., 5, .T., .F.)
    Private oFontDetN  := TFont():New(cNomeFont, 9, -13, .T., .T., 5, .T., 5, .T., .F.)
    Private oFontRod   := TFont():New(cNomeFont, 9, -8,  .T., .F., 5, .T., 5, .T., .F.)
    Private oFontMin   := TFont():New(cNomeFont, 9, -7,  .T., .F., 5, .T., 5, .T., .F.)
    Private oFontTit   := TFont():New(cNomeFont, 9, -15, .T., .T., 5, .T., 5, .T., .F.)
     
    //Monta a consulta de dados
    cQryAux += "SELECT "		+ CRLF
    cQryAux += " B1_COD, "		+ CRLF
    cQryAux += " B1_DESC, "		+ CRLF
    cQryAux += " B1_GRUPO, "		+ CRLF
    cQryAux += " BM_DESC "		+ CRLF
    cQryAux += "FROM "		+ CRLF
    cQryAux += " SB1990 SB1 "		+ CRLF
    cQryAux += " INNER JOIN SBM990 SBM ON ( "		+ CRLF
    cQryAux += " BM_FILIAL = '01' "		+ CRLF
    cQryAux += " AND BM_GRUPO = B1_GRUPO "		+ CRLF
    cQryAux += " AND SBM.D_E_L_E_T_ = ' ' "		+ CRLF
    cQryAux += " ) "		+ CRLF
    cQryAux += "WHERE "		+ CRLF
    cQryAux += " B1_FILIAL = '' "		+ CRLF
    cQryAux += " AND B1_COD >= '" + MV_PAR01 + "' "		+ CRLF
    cQryAux += " AND B1_COD <= '" + MV_PAR02 + "' "		+ CRLF
    cQryAux += " AND B1_MSBLQL != '1' "		+ CRLF
    cQryAux += " AND SB1.D_E_L_E_T_ = ' '"		+ CRLF
    PLSQuery(cQryAux, 'QRY_AUX')
 
    //Define o tamanho da r�gua
    DbSelectArea('QRY_AUX')
    QRY_AUX->(DbGoTop())
    Count to nTotAux
    ProcRegua(nTotAux)
    QRY_AUX->(DbGoTop())
     
    //Somente se tiver dados
    If ! QRY_AUX->(EoF())
        //Criando o objeto de impressao
        oPrintPvt := FWMSPrinter():New(cArquivo, IMP_PDF, .F., ,   .T., ,    @oPrintPvt, ,   ,    , ,.T.)
        oPrintPvt:cPathPDF := GetTempPath()
        oPrintPvt:SetResolution(72)
        oPrintPvt:SetPortrait()
        oPrintPvt:SetPaperSize(DMPAPER_A4)
        oPrintPvt:SetMargin(0, 0, 0, 0)
 
        //Imprime os dados
        fImpCab()
        While ! QRY_AUX->(EoF())
            nAtuAux++
            IncProc('Imprimindo registro ' + cValToChar(nAtuAux) + ' de ' + cValToChar(nTotAux) + '...')
 
            //Se atingiu o limite, quebra de pagina
            fQuebra()
             
            //Faz o zebrado ao fundo
            If nAtuAux % 2 == 0
                oPrintPvt:FillRect({nLinAtu - 2, nColIni, nLinAtu + 12, nColFin}, oBrushLin)
            EndIf
 
            //Imprime a linha atual
            oPrintPvt:SayAlign(nLinAtu, nColDad1, Alltrim(QRY_AUX->B1_COD), oFontDet, 50, 10, /*nClrText*/, PAD_LEFT, /*nAlignVert*/)
            oPrintPvt:SayAlign(nLinAtu, nColDad2, Alltrim(QRY_AUX->B1_DESC), oFontDetN, 100, 10, /*nClrText*/, PAD_LEFT, /*nAlignVert*/)
            oPrintPvt:SayAlign(nLinAtu, nColDad3, Alltrim(QRY_AUX->B1_GRUPO), oFontDet, 50, 10, /*nClrText*/, PAD_LEFT, /*nAlignVert*/)
            oPrintPvt:SayAlign(nLinAtu, nColDad4, Alltrim(QRY_AUX->BM_DESC), oFontDet, 100, 10, /*nClrText*/, PAD_LEFT, /*nAlignVert*/)
 
            nLinAtu += 15
            oPrintPvt:Line(nLinAtu-3, nColIni, nLinAtu-3, nColFin, nCorCinza)
 
            //Se atingiu o limite, quebra de pagina
            fQuebra()
             
            QRY_AUX->(DbSkip())
        EndDo
        fImpRod()
         
        oPrintPvt:Preview()
    Else
        MsgStop('N�o foi encontrado informa��es com os par�metros informados!', 'Aten��o')
    EndIf
    QRY_AUX->(DbCloseArea())
     
    RestArea(aArea)
Return

/*/{Protheus.doc} fLogoEmp
Fun��o que retorna o logo da empresa conforme configura��o da DANFE
@author Atilio
@since 20/02/2023
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
@see http://autumncodemaker.com
/*/

Static Function fLogoEmp()
    Local cGrpCompany := AllTrim(FWGrpCompany())
    Local cCodEmpGrp  := AllTrim(FWCodEmp())
    Local cUnitGrp    := AllTrim(FWUnitBusiness())
    Local cFilGrp     := AllTrim(FWFilial())
    Local cLogo       := ''
    Local cCamFim     := GetTempPath()
    Local cStart      := GetSrvProfString('Startpath', '')

    //Se tiver filiais por grupo de empresas
    If !Empty(cUnitGrp)
        cDescLogo	:= cGrpCompany + cCodEmpGrp + cUnitGrp + cFilGrp
        
    //Sen�o, ser� apenas, empresa + filial
    Else
        cDescLogo	:= cEmpAnt + cFilAnt
    EndIf
    
    //Pega a imagem
    cLogo := cStart + 'DANFE' + cDescLogo + '.BMP'
    
    //Se o arquivo n�o existir, pega apenas o da empresa, desconsiderando a filial
    If !File(cLogo)
        cLogo	:= cStart + 'DANFE' + cEmpAnt + '.BMP'
    EndIf
    
    //Copia para a tempor�ria do s.o.
    CpyS2T(cLogo, cCamFim)
    cLogo := cCamFim + StrTran(cLogo, cStart, '')
    
    //Se o arquivo n�o existir na tempor�ria, espera meio segundo para terminar a c�pia
    If !File(cLogo)
        Sleep(500)
    EndIf
Return cLogo

/*/{Protheus.doc} fImpCab
Fun��o que imprime o cabe�alho do relat�rio
@author Atilio
@since 20/02/2023
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
@see http://autumncodemaker.com
/*/

Static Function fImpCab()
    Local cTexto   := ''
    Local nLinCab  := 015
     
    //Iniciando Pagina
    oPrintPvt:StartPage()
    
    //Imprime o logo
    If File(cLogoEmp)
        oPrintPvt:SayBitmap(005, nColIni, cLogoEmp, 030, 030)
    EndIf
     
    //Cabecalho
    cTexto := 'Produtos e Grupos'
    oPrintPvt:SayAlign(nLinCab, nColMeio-200, cTexto, oFontTit, 400, 20, , PAD_CENTER, )
     
    //Linha Separatoria
    nLinCab += 020
    oPrintPvt:Line(nLinCab,   nColIni, nLinCab,   nColFin)
     
    //Atualizando a linha inicial do relatorio
    nLinAtu := nLinCab + 5
    
    If nPagAtu == 1
        //Imprimindo os par�metros
        oPrintPvt:SayAlign(nLinAtu, nColIni, 'Produto De', oFontDetN, 200, 10, /*nClrText*/, PAD_LEFT, /*nAlignVert*/)
        oPrintPvt:SayAlign(nLinAtu, nColIni+200, MV_PAR01, oFontDet, 200, 10, /*nClrText*/, PAD_LEFT, /*nAlignVert*/)
        nLinAtu += 15
        oPrintPvt:SayAlign(nLinAtu, nColIni, 'Produto At�', oFontDetN, 200, 10, /*nClrText*/, PAD_LEFT, /*nAlignVert*/)
        oPrintPvt:SayAlign(nLinAtu, nColIni+200, MV_PAR02, oFontDet, 200, 10, /*nClrText*/, PAD_LEFT, /*nAlignVert*/)
        nLinAtu += 15
        oPrintPvt:Line(nLinAtu-3, nColIni, nLinAtu-3, nColFin, nCorCinza)
        nLinAtu += 5
    EndIf
    
    oPrintPvt:SayAlign(nLinAtu, nColDad1, 'Produto', oFontMin, 50, 10, /*nClrText*/, PAD_LEFT, /*nAlignVert*/)
    oPrintPvt:SayAlign(nLinAtu, nColDad2, 'Descri��o', oFontMin, 100, 10, /*nClrText*/, PAD_LEFT, /*nAlignVert*/)
    oPrintPvt:SayAlign(nLinAtu, nColDad3, 'Grupo', oFontMin, 50, 10, /*nClrText*/, PAD_LEFT, /*nAlignVert*/)
    oPrintPvt:SayAlign(nLinAtu, nColDad4, 'Grp. Descri��o', oFontMin, 100, 10, /*nClrText*/, PAD_LEFT, /*nAlignVert*/)
    nLinAtu += 15
Return

/*/{Protheus.doc} fImpRod
Fun��o que imprime o rodap� e encerra a p�gina
@author Atilio
@since 20/02/2023
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
@see http://autumncodemaker.com
/*/

Static Function fImpRod()
    Local nLinRod:= nLinFin
    Local cTexto := ''
 
    //Linha Separatoria
    oPrintPvt:Line(nLinRod,   nColIni, nLinRod,   nColFin)
    nLinRod += 3
     
    //Dados da Esquerda
    cTexto := dToC(dDataBase) + '     ' + cHoraEx + '     ' + FunName() + ' (zExe236)     ' + UsrRetName(RetCodUsr())
    oPrintPvt:SayAlign(nLinRod, nColIni, cTexto, oFontRod, 500, 10, , PAD_LEFT, )
     
    //Direita
    cTexto := 'Pagina '+cValToChar(nPagAtu)
    oPrintPvt:SayAlign(nLinRod, nColFin-40, cTexto, oFontRod, 040, 10, , PAD_RIGHT, )
     
    //Finalizando a pagina e somando mais um
    oPrintPvt:EndPage()
    nPagAtu++
Return

/*/{Protheus.doc} fQuebra
Fun��o que valida se a linha esta pr�xima do final, se sim quebra a p�gina
@author Atilio
@since 20/02/2023
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
@see http://autumncodemaker.com
/*/

Static Function fQuebra()
    If nLinAtu >= nLinFin-10
        fImpRod()
        fImpCab()
    EndIf
Return
