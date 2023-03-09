%% Information
% =================================================================================================
% Yufei Li
% Princeton University
% yl5385@princeton.edu
% 
% Feburay 2023
% ==================================================================================================
%% AC Sweep
clear
% load('Ydq50op171_bw100.mat', 'Ydq')
N=50;
fmin=1;
fmax=1e3;
VL_L=400;
VG_PEAK=VL_L/sqrt(3)*sqrt(2);
L=3e-3;
R=80e-3;
Vdc=700;
w=2*pi*50;
P0=30e3;
Q0=30e3;
ID0=P0/VL_L;
IQ0=Q0/VL_L;
% V, P, Q, Id, Iq
k=1;
for jv=0.9:0.1:1.1
    for jp=-1:0.5:1
        for jq=-1:0.5:1
            Vg_peak=jv*VG_PEAK; %voltage amplitude
            Vperturb=Vg_peak*1e-3;%voltage perturbation amplitude
            Vl_l=jv*VL_L; %line-to-line voltage
            P=jp*P0; %active power
            Q=jq*Q0; %reactive power
            Id=P/Vl_l; %d-axis current
            Iq=Q/Vl_l;  %q-axis current
            I=sqrt(Id^2+Iq^2);
            if (sqrt((Vg_peak+Id*R-Iq*w*L)^2+(Id*w*L)^2)<=Vdc/2&&I<1.1*ID0&&sqrt(Id^2+Iq^2)>0) %power constraints(restrictions)
                O(k,:)=[Vg_peak P Q];
                O1(k,:)=[jv jp jq];
                Ydq(k).V=O1(k,1);
                Ydq(k).P=O1(k,2);
                Ydq(k).Q=O1(k,3);
                for x=1:4
                    switch x
                        case 1
                            S1=0;
                            S2=0;%Defining the model as Ydd
                            placsweep('ML_2L_GFL_Y_Measure_AC_Sweep_2023/AC Sweep');%dq admittance collection using PLECS AC sweep
%                             Ydq(k).fdd=Y.F;
                            Ydq(k).f=Y.F;
                            Ydq(k).Y(:,1)=Y.G;
                        case 2
                            S1=0;
                            S2=1;%Defining the model as Ydq
                            placsweep('ML_2L_GFL_Y_Measure_AC_Sweep_2023/AC Sweep');%dq admittance collection using PLECS AC sweep
%                             Ydq(k).fdq=Y.F;
                            Ydq(k).Y(:,2)=Y.G;
                        case 3
                            S1=1;
                            S2=0;%Defining the model as Yqd
                            placsweep('ML_2L_GFL_Y_Measure_AC_Sweep_2023/AC Sweep');%dq admittance collection using PLECS AC sweep
%                             Ydq(k).fqd=Y.F;
                            Ydq(k).Y(:,3)=Y.G;
                        case 4
                            S1=1;
                            S2=1;%Defining the model as Yqq
                            placsweep('ML_2L_GFL_Y_Measure_AC_Sweep_2023/AC Sweep');%dq admittance collection using PLECS AC sweep
%                             Ydq(k).fqq=Y.F;
                            Ydq(k).Y(:,4)=Y.G;
                    end
                end
                save('Ydq50op24_PLL.mat','Ydq');
                k=k+1;
            end
        end
    end
end