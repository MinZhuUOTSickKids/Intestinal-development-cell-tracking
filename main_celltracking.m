%%data imported as column vectors
%the data should be in following default Imaris exported excel format 
%Position X	Position Y	Position Z	Unit	Category	Collection	Time	TrackID	ID
%Position X_Bead	Position Y_Bead	Position Z_Bead	Unit_Bead	Category_Bead	Collection_Bead	Time_Bead	TrackID	ID_Bead

%% drift compensation
tracks=min(TrackID);
trackf=max(TrackID);

for i=tracks:1:trackf
    x=find(TrackID==i); %row number
    time=Time(x); %time info 
    temp0=find (Time_Bead==time(1));
    PositionXD(x(1),1)=PositionX(x(1));
    PositionYD(x(1),1)=PositionY(x(1));
    PositionZD(x(1),1)=PositionZ(x(1));
    for j=2:1:length(x)  
        temp=find(Time_Bead==time(j));
        PositionXD(x(j),1)=PositionX(x(j))-(PositionX_Bead(temp)-PositionX_Bead(temp0));
        PositionYD(x(j),1)=PositionY(x(j))-(PositionY_Bead(temp)-PositionY_Bead(temp0));
        PositionZD(x(j),1)=PositionZ(x(j))-(PositionZ_Bead(temp)-PositionZ_Bead(temp0));
    end
end
%% peristaltic wave phase sorting
tracks=min(TrackID);
trackf=max(TrackID);
f=15;  % peristaltic wave time slice interval
ind=1;
for i=tracks:1:trackf
    x=find(TrackID==i); %row number
for j=1:f:length(x)  
    PositionXF(ind,1)= PositionXD(x(j));
    PositionYF(ind,1)= PositionYD(x(j));
    PositionZF(ind,1)= PositionZD(x(j));
    ind=ind+1;
end
end

%% 2D rotation for plotting if necessary
CenterX=400;CenterY=400; %enter center coordinates here to center the tracking data for rotation
PositionXF=PositionXF-CenterX;
PositionYF=PositionYF-CenterY;
theta = 45; % to rotate 45 counterclockwise enter the angle here
R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];

for ii=1:1:length(PositionXF)
rotatedxy=R*[PositionXF(ii);PositionYF(ii)];
PositionXF(ii)=rotatedxy(1);
PositionYF(ii)=rotatedxy(2);
end
%% plot cell migration using arrow function
figure ();
hold on
for i=tracks:1:trackf 
    x=find(TrackID==i);
    arrow([PositionXF(x(1)) PositionYF(x(1))],[PositionXF(x(end)) PositionYF(x(end))],'Width',0.2,'Length',2);
    end

%% angle caculation
ind1=1;
for i= min(TrackID):1:max(TrackID)
    x=find(TrackID==i);
    if PositionXF(x(1))>390&&PositionXF(x(1))<417&&PositionYF(x(1))<320&&PositionYF(x(1))>240
    angle(ind1,1)=anglecal(PositionXF(x(1)),PositionXF(x(end)),PositionYF(x(1)),PositionYF(x(end)));
    ind1=ind1+1;
    end
end
disp 'end'
%% rose plot
anglef=[angle; angle+pi];
figure ()
rose(anglef,20);
