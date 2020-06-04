#!/bin/bash
#SBATCH -J proc
#SBATCH -o emi_proc%j.o
#SBATCH -n 4
#SBATCH --ntasks-per-node=24
#SBATCH -p id
ProcessDir=$PWD
echo $ProcessDir

cp ../wrfchemi_d01_2019-09-01_00:00:00   wrfchemi.nc
echo "Copia emisiones"
ncap2 -A -v -s E_ETH=E_CO wrfchemi.nc wrfchemi.nc
ncap2 -A -v -s E_HC3=E_CO wrfchemi.nc wrfchemi.nc
ncap2 -A -v -s E_HC5=E_CO wrfchemi.nc wrfchemi.nc
ncap2 -A -v -s E_HC8=E_CO wrfchemi.nc wrfchemi.nc
ncap2 -A -v -s E_HCHO=E_CO wrfchemi.nc wrfchemi.nc
ncap2 -A -v -s E_NH3=E_CO wrfchemi.nc wrfchemi.nc
ncap2 -A -v -s E_SO2=E_CO wrfchemi.nc wrfchemi.nc
ncap2 -A -v -s E_OLI=E_CO wrfchemi.nc wrfchemi.nc
ncap2 -A -v -s E_OL2=E_CO wrfchemi.nc wrfchemi.nc
ncap2 -A -v -s E_TOL=E_CO wrfchemi.nc wrfchemi.nc
ncap2 -A -v -s E_OLT=E_CO wrfchemi.nc wrfchemi.nc
rm E_*.nc
echo "mascaras"
# Extrae la emision de CO
ncks -O -v E_CO wrfchemi.nc emiss.nc
# Borra emisiones para obtener efecto de las fronteras
ncap2 -s E_CO=E_CO*0 emiss.nc E_CO.nc
echo "Boundary"
# Extrae la emision de CO
ncks -O -v E_OLT wrfchemi.nc emiss.nc
# transpone la valiable XLAT
ncpdq -O -a -XLAT  SUMA_MASCARAS_ZM_mas_EdoMex.nc m_trasnp.nc
#Renombre variables
ncrename -O -d XLAT,south_north -d XLONG,west_east m_trasnp.nc
# Pega la mascara en las emisiones
ncks -C -v Reclass_MASCARA_ZM_EdoMex_pointToRaster -A m_trasnp.nc  emiss.nc
#calcula la mascara Fondo
ncap2 -s E_OLT=E_OLT*Reclass_MASCARA_ZM_EdoMex_pointToRaster emiss.nc E_OLT.nc
echo "Background"
# Estado de Mexico alrededor de la CDMX
ncpdq -O -a -XLAT  MASCARA_2_ZM_EdoMex.nc m_trasnp.nc
#Renombre variables
ncrename -O -d XLAT,south_north -d XLONG,west_east m_trasnp.nc
# Extrae la emision de HCHO
ncks -O -v E_HCHO wrfchemi.nc emiss.nc
# Pega la mascara en las emisiones
ncks -C -v Reclass_MASCARA_ZM_EdoMex_pointToRaster -A m_trasnp.nc  emiss.nc
#calcula la mascara
ncap2 -s 'E_HCHO=E_HCHO*(1-Reclass_MASCARA_ZM_EdoMex_pointToRaster)' emiss.nc E_HCHO.nc
echo "Toluca"
# Estado de Mexico Toluca
ncpdq -O -a -LATITUDE  MASCARA_ZM_TOLUCA.nc m_trasnp.nc
#Renombre variables
ncrename -O -d LATITUDE,south_north -d LONG,west_east m_trasnp.nc
# Extrae la emision de OLI
ncks -O -v E_OLI wrfchemi.nc emiss.nc
# Pega la mascara en las emisiones
ncks -C -v MASCARA_ZM_TOLUCA -A m_trasnp.nc  emiss.nc
#calcula la mascara
ncap2 -s E_OLI=E_OLI*MASCARA_ZM_TOLUCA emiss.nc E_OLI.nc
echo "Cuautla"
# Estado de Morelos Cuautla
ncpdq -O -a -LATITUDE  MASCARA_ZM_CUAUTLA.nc m_trasnp.nc
#Renombre variables
ncrename -O -d LATITUDE,south_north -d LONG,west_east m_trasnp.nc
# Extrae la emision de OL2
ncks -O -v E_OL2 wrfchemi.nc emiss.nc
# Pega la mascara en las emisiones
ncks -C -v MASCARA_ZM_CUAUTLA -A m_trasnp.nc  emiss.nc
#calcula la mascara
ncap2 -s E_OL2=E_OL2*MASCARA_ZM_CUAUTLA emiss.nc E_OL2.nc
echo "Cuernavaca"
# Estado de Morelos Cuernavaca
ncpdq -O -a -LATITUDE  MASCARA_ZM_CUERNAVACA.nc m_trasnp.nc
#Renombre variables
ncrename -O -d LATITUDE,south_north -d LONG,west_east m_trasnp.nc
# Extrae la emision de NH3
ncks -O -v E_NH3 wrfchemi.nc emiss.nc
# Pega la mascara en las emisiones
ncks -C -v MASCARA_ZM_CUERNAVACA -A m_trasnp.nc  emiss.nc
#calcula la mascara
ncap2 -s E_NH3=E_NH3*MASCARA_ZM_CUERNAVACA emiss.nc E_NH3.nc
echo "Mascara de CDMX"
# Estado de CDMX
ncpdq -O -a -LATITUDE  MASCARA_ZM_DF.nc m_trasnp.nc
#Renombre variables
ncrename -O -d LATITUDE,south_north -d LONG,west_east m_trasnp.nc
# Extrae la emision de SO2
ncks -O -v E_SO2 wrfchemi.nc emiss.nc
# Pega la mascara en las emisiones
ncks -C -v MASCARA_ZM_DF -A m_trasnp.nc  emiss.nc
#calcula la mascara
ncap2 -s E_SO2=E_SO2*MASCARA_ZM_DF emiss.nc E_SO2.nc
echo "   Pachuca"
# Estado de Hidalgo Pachuca
ncpdq -O -a -LATITUDE  MASCARA_ZM_PACHUCA.nc m_trasnp.nc
#Renombre variables
ncrename -O -d LATITUDE,south_north -d LONG,west_east m_trasnp.nc
# Extrae la emision de HC3
ncks -O -v E_HC3 wrfchemi.nc emiss.nc
# Pega la mascara en las emisiones
ncks -C -v MASCARA_ZM_PACHUCA -A m_trasnp.nc  emiss.nc
#calcula la mascara
ncap2 -s E_HC3=E_HC3*MASCARA_ZM_PACHUCA emiss.nc E_HC3.nc
echo "    Tula"
# Estado de Hidalgo Tula
ncpdq -O -a -LATITUDE  MASCARA_ZM_TULA.nc m_trasnp.nc
#Renombre variables
ncrename -O -d LATITUDE,south_north -d LONG,west_east m_trasnp.nc
# Extrae la emision de HC5
ncks -O -v E_HC5 wrfchemi.nc emiss.nc
# Pega la mascara en las emisiones
ncks -C -v MASCARA_ZM_TULA -A m_trasnp.nc  emiss.nc
#calcula la mascara
ncap2 -s E_HC5=E_HC5*MASCARA_ZM_TULA emiss.nc E_HC5.nc
echo "    Tulancingo"
# Estado de Hidalgo Tulancingo
ncpdq -O -a -LATITUDE  MASCARA_ZM_TULANCINGO.nc m_trasnp.nc
#Renombre variables
ncrename -O -d LATITUDE,south_north -d LONG,west_east m_trasnp.nc
# Extrae la emision de HC8
ncks -O -v E_HC8 wrfchemi.nc emiss.nc
# Pega la mascara en las emisiones
ncks -C -v MASCARA_ZM_TULANCINGO -A m_trasnp.nc  emiss.nc
#calcula la mascara
ncap2 -s E_HC8=E_HC8*MASCARA_ZM_TULANCINGO emiss.nc E_HC8.nc
echo "Puebla"
# Estado de Puebla 
ncpdq -O -a -XLAT  MASCARA_ZM_PUEBLA_con1s.nc m_trasnp.nc
#Renombre variables
ncrename -O -d XLAT,south_north -d XLONG,west_east m_trasnp.nc
# Extrae la emision de TOL
ncks -O -v E_TOL wrfchemi.nc emiss.nc
# Pega la mascara en las emisiones
ncks -C -v MASCARAS_ZM_PUEBLA_PointToRaster -A m_trasnp.nc  emiss.nc
#calcula la mascara
ncap2 -s E_TOL=E_TOL*MASCARAS_ZM_PUEBLA_PointToRaster emiss.nc E_TOL.nc
echo "Tlaxcala"
# Estado de Tlaxcala
ncpdq -O -a -XLAT MASCARA_ZM_Tlaxcala_Apizaco_con1s.nc m_trasnp.nc
#Renombre variables
ncrename -O -d XLAT,south_north -d XLONG,west_east m_trasnp.nc
# Extrae la emision de ETH
ncks -O -v E_ETH wrfchemi.nc emiss.nc
# Pega la mascara en las emisiones
ncks -C -v MASCARAS_ZM_Tlaxcala_Apizaco_PointToRaster -A m_trasnp.nc  emiss.nc
#calcula la mascara
ncap2 -s E_ETH=E_ETH*MASCARAS_ZM_Tlaxcala_Apizaco_PointToRaster emiss.nc E_ETH.nc

# Pega las emisiones en el de emisiones
echo "Adiciona emisiones al archivo de emisiones"
ncks -O -v Times wrfchemi.nc salida.nc
ncks -C -v E_CO   -A E_CO.nc salida.nc
ncks -C -v E_HC3  -A E_HC3.nc salida.nc
ncks -C -v E_HC5  -A E_HC5.nc salida.nc
ncks -C -v E_HC8  -A E_HC8.nc salida.nc
ncks -C -v E_HCHO -A E_HCHO.nc salida.nc
ncks -C -v E_NH3  -A E_NH3.nc salida.nc
ncks -C -v E_SO2  -A E_SO2.nc salida.nc
ncks -C -v E_OLT  -A E_OLT.nc salida.nc
ncks -C -v E_OLI  -A E_OLI.nc salida.nc
ncks -C -v E_OL2  -A E_OL2.nc salida.nc
ncks -C -v E_TOL  -A E_TOL.nc salida.nc
ncks -C -v E_ETH  -A E_ETH.nc salida.nc
exit 0
