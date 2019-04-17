clear; close all;
[A900 R900]=geotiffread('c20171012_oceanit_914m_ti.tif');
[A30 R30]=geotiffread('c20171012_oceanit_30m_tir.tif');
y900=R900.YWorldLimits(1)+R900.CellExtentInWorldY/2:R900.CellExtentInWorldY:R900.YWorldLimits(2)-R900.CellExtentInWorldY;
x900=R900.XWorldLimits(1)+R900.CellExtentInWorldX/2:R900.CellExtentInWorldX:R900.XWorldLimits(2)-R900.CellExtentInWorldX/2;
x30=R30.XWorldLimits(1)+R30.CellExtentInWorldX:R30.CellExtentInWorldX:R30.XWorldLimits(2)-R30.CellExtentInWorldX;
y30=R30.YWorldLimits(1)+R30.CellExtentInWorldY:R30.CellExtentInWorldY:R30.YWorldLimits(2)-R30.CellExtentInWorldX;
%find overlap
xs(1)=max(find(x30(1)>=x900)); %index in x900 that is the same as x30
ys(1)=max(find(y30(1)>=y900)); %index in y900 that is the same as y30
xs(2)=min(find(x30(end)<=x900)); %index in x900 that is the same as x30(end)
ys(2)=min(find(y30(end)<=y900)); %index in x900 that is the same as x30(end)
figure(); imagesc(A30);
figure(); imagesc(A900); xlim(xs); ylim(ys);

