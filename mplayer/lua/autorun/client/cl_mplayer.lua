AddCSLuaFile() --Создатель Pirizuka

local rain = 0
local bplus = 0
local playing = false
local station = nil
local loop = false


surface.CreateFont("ma_roboto",{
	font = "Roboto",
	size = 15,
	weight = 5000,
	extended = true,
	shadow = true
})

function createAudio(url)
	sound.PlayURL(url,"mono noblock", function(stati,errorid,errortext)
		if IsValid(station) then station:Stop() station=nil end
		if IsValid(stati) then
			station=stati
			lasturl=url
			station:SetPos(LocalPlayer():GetPos())
			station:EnableLooping(loop)
			station:Play()
			playing=true
		end
	end)
end

function openDerma()

	local a = vgui.Create("DFrame")
	a:SetSize(0,350)
	a:SetTitle("MPlayer")
	a:MakePopup()
	a:ShowCloseButton(true)

	local te1 = vgui.Create("DTextEntry",a)
	te1:SetSize( 300, 35 )
	te1:SetPos( 200, 25, 20)
	te1:SetText(LocalPlayer():GetPData("MA_LASTTRACKURL"," >_< "))

	te1.OnTextChanged = function()
		LocalPlayer():SetPData("MA_LASTTRACKURL",te1:GetValue())
	end

	local b2 = vgui.Create("DButton",a)
	b2:SetSize( 200, 35 )
	b2:SetPos( 250, 177, 5 )
	b2:SetText("Включить")

	b2.DoClick = function()
		createAudio(te1:GetValue())
	end

	local b3 = vgui.Create("DButton",a)
	b3:SetSize( 120, 35 )
	b3:SetPos( 280, 300, 5)
	b3:SetText("Пауза/Продолжить")

	b3.DoClick = function()
		if IsValid(station) then if station:GetState() == 1 then playing = false station:Pause() elseif station:GetState() == 2 then station:Play() playing = true end end
	end

	local b4 = vgui.Create("DButton",a)
	b4:SetSize( 70,35 )
	b4:SetPos( 300, 216, 5)
	b4:SetText("Стоп")
	b4.DoClick = function()
		if IsValid(station) then if station:GetState() == 1 or station:GetState() == 2 then station:Stop() playing=false station=nil end end
	end

	local b5 = vgui.Create("DButton",a)
	b5:SetSize( 70, 35 )
	b5:SetPos( 300, 100, 5 )
	b5:SetText("Громче")

	b5.DoClick = function()
		if IsValid(station) then station:SetVolume(station:GetVolume()+0.05) end
	end

	local b6 = vgui.Create("DButton",a)
	b6:SetSize( 70, 35 )
	b6:SetPos( 300, 140, 5)
	b6:SetText("Тише")
	
	b6.DoClick = function()
		if IsValid(station) then station:SetVolume(station:GetVolume()-0.05) end
	end

	local b7 = vgui.Create("DButton",a)
	b7:SetSize( 70, 35 )
	b7:SetPos( 300, 255, 5 )
	b7:SetText("Повтор")
	b7.DoClick = function()
		loop=!loop
		if IsValid(station) then station:EnableLooping(loop) end
	end















	a.Think = function(me)
		if a.center == true then
			me:Center()
		end
	end
	
end

hook.Add("OnPlayerChat","ma_chat",function(ply,text,dead,team)
	if ply==LocalPlayer() then
		if text == "!mplayer" then

			openDerma()

		end
	end
end)

concommand.Add("sekta_music", function()
	openDerma()
end)

hook.Add("Think","ma_think",function()
	rain=rain+1
	bplus=(1/RealFrameTime())/10
	if playing then
		station:SetPos(LocalPlayer():GetPos())
	end
end)

--Типа сверху разноцветное

hook.Add("HUDPaint","ma_paint",function()
	if playing and station:GetState() != 2 and station:GetState() != 0 then
		local data = {}
		station:FFT(data,FFR_512)	
		local plus = (ScrW()/250)
		for i = 1, 250 do
			local rainbow = (i*(255/250))+rain
			draw.RoundedBox(8, i*(plus), -1, plus+1, data[i]*550, HSVToColor(rainbow,1,1))
		end
	end
end)
