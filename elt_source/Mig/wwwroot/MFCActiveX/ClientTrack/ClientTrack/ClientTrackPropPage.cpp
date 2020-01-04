// ClientTrackPropPage.cpp : Implementation of the CClientTrackPropPage property page class.

#include "stdafx.h"
#include "ClientTrack.h"
#include "ClientTrackPropPage.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


IMPLEMENT_DYNCREATE(CClientTrackPropPage, COlePropertyPage)



// Message map

BEGIN_MESSAGE_MAP(CClientTrackPropPage, COlePropertyPage)
END_MESSAGE_MAP()



// Initialize class factory and guid

IMPLEMENT_OLECREATE_EX(CClientTrackPropPage, "CLIENTTRACK.ClientTrackPropPage.1",
	0x8c7124cb, 0xaba, 0x41ef, 0x98, 0x96, 0xf3, 0xe8, 0xcf, 0xce, 0xaa, 0x21)



// CClientTrackPropPage::CClientTrackPropPageFactory::UpdateRegistry -
// Adds or removes system registry entries for CClientTrackPropPage

BOOL CClientTrackPropPage::CClientTrackPropPageFactory::UpdateRegistry(BOOL bRegister)
{
	if (bRegister)
		return AfxOleRegisterPropertyPageClass(AfxGetInstanceHandle(),
			m_clsid, IDS_CLIENTTRACK_PPG);
	else
		return AfxOleUnregisterClass(m_clsid, NULL);
}



// CClientTrackPropPage::CClientTrackPropPage - Constructor

CClientTrackPropPage::CClientTrackPropPage() :
	COlePropertyPage(IDD, IDS_CLIENTTRACK_PPG_CAPTION)
{
}



// CClientTrackPropPage::DoDataExchange - Moves data between page and properties

void CClientTrackPropPage::DoDataExchange(CDataExchange* pDX)
{
	DDP_PostProcessing(pDX);
}



// CClientTrackPropPage message handlers
