--created & coded by Lyris, art by G.River of Pixiv
--「S・VINE」アストラル・ドラゴン(アナザー宙)
c240100435.spt_another_space=240100432
function c240100435.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddOrigSpatialType(c)
	aux.AddSpatialProc(c,nil,8,600,nil,aux.TRUE,aux.TRUE)
end