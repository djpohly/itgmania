#include "global.h"
#include "SongPosition.h"

static Preference<float> g_fVisualDelaySeconds( "VisualDelaySeconds", 0.0f );

void SongPosition::UpdateSongPosition( float fPositionSeconds, const TimingData &timing, const RageTimer &timestamp, float fAdditionalVisualDelay )
{

	if( !timestamp.IsZero() )
		m_LastBeatUpdate = timestamp;
	else
		m_LastBeatUpdate.Touch();

	TimingData::GetBeatArgs beat_info;
	beat_info.elapsed_time= fPositionSeconds;
	timing.GetBeatAndBPSFromElapsedTime(beat_info);
	m_fSongBeat= beat_info.beat;
	m_fCurBPS= beat_info.bps_out;
	m_bFreeze= beat_info.freeze_out;
	m_bDelay= beat_info.delay_out;
	m_iWarpBeginRow= beat_info.warp_begin_out;
	m_fWarpDestination= beat_info.warp_dest_out;
	
	// "Crash reason : -243478.890625 -48695.773438"
	// The question is why is -2000 used as the limit? -aj
	ASSERT_M( m_fSongBeat > -2000, ssprintf("Song beat %f at %f seconds is less than -2000!", m_fSongBeat, fPositionSeconds) );

	m_fMusicSeconds = fPositionSeconds;

	m_fLightSongBeat = timing.GetBeatFromElapsedTime( fPositionSeconds + g_fLightsAheadSeconds );

	m_fSongBeatNoOffset = timing.GetBeatFromElapsedTimeNoOffset( fPositionSeconds );
	
	m_fMusicSecondsVisible = fPositionSeconds - g_fVisualDelaySeconds.Get() - fAdditionalVisualDelay;
	beat_info.elapsed_time= m_fMusicSecondsVisible;
	timing.GetBeatAndBPSFromElapsedTime(beat_info);
	m_fSongBeatVisible= beat_info.beat;
}

void SongPosition::Reset()
{

	m_fMusicSecondsVisible = 0;
	m_fSongBeatVisible = 0;

	m_fMusicSeconds = 0; // MUSIC_SECONDS_INVALID;
	// todo: move me to FOREACH_EnabledPlayer( p ) after [NUM_PLAYERS]ing
	m_fSongBeat = 0;
	m_fSongBeatNoOffset = 0;
	m_fCurBPS = 10;
	//m_bStop = false;
	m_bFreeze = false;
	m_bDelay = false;
	m_iWarpBeginRow = -1; // Set to -1 because some song may want to warp to row 0. -aj
	m_fWarpDestination = -1; // Set when a warp is encountered. also see above. -aj

}

//lua start
#include "LuaBinding.h"
class LunaSongPosition: public Luna<SongPosition>
{
public:
	LUA_DEFINE_METHOD( GetMusicSecondsVisible, m_fMusicSecondsVisible );
	LUA_DEFINE_METHOD( GetSongBeatVisible, m_fSongBeatVisible );
	LUA_DEFINE_METHOD( GetMusicSeconds, m_fMusicSeconds );
	LUA_DEFINE_METHOD( GetSongBeat, m_fSongBeat );
	LUA_DEFINE_METHOD( GetSongBeatNoOffset, m_fSongBeatNoOffset );
	LUA_DEFINE_METHOD( GetCurBPS, m_fCurBPS );
	LUA_DEFINE_METHOD( GetFreeze, m_bFreeze );
	LUA_DEFINE_METHOD( GetDelay, m_bDelay );
	LUA_DEFINE_METHOD( GetWarpBeginRow, m_iWarpBeginRow );
	LUA_DEFINE_METHOD( GetWarpDestination, m_fWarpDestination );
};

LUA_REGISTER_CLASS( SongPosition );
/**
 * @file
 * @author Thai Pangsakulyanont (c) 2011
 * @section LICENSE
 * All rights reserved.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, and/or sell copies of the Software, and to permit persons to
 * whom the Software is furnished to do so, provided that the above
 * copyright notice(s) and this permission notice appear in all copies of
 * the Software and that both the above copyright notice(s) and this
 * permission notice appear in supporting documentation.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF
 * THIRD PARTY RIGHTS. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS
 * INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT
 * OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS
 * OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
 * OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
 * PERFORMANCE OF THIS SOFTWARE.
 */

