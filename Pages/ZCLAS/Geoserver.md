---
layout: default
title: Geoserver
parent: ZCLAS
nav_order: 2
---

# ZCLAS Geoserver

_ZCLAS uses a geoserver to host all of its spatial layers. The server hosts layers such as chiefdom boundaries, parcel boundaries, villages as well as a Google satellite background layer. In order to add additional layers to the maps in ZCLAS, you must add that layer to the Geoserver, and then configure it in ZCLAS._ 

The [Geoserver Documentation](https://docs.geoserver.org/) includes guides on styling and getting started. 

### Requirements
- Geoserver with login credentials
    - The geoserver for ZCLAS is located at: 13.244.91.45:8080/geoserver/web
    - Ask a supervisor or project manager for the username and password
- Access to the server through Webmin or PuTTY

## Upload Spatial Files to Server
- Download the spatial files you want to upload onto ZCLAS and unzip. The folder should contain all the files needed to properly load and display the layer. 

![Geoserver1](/Pages/ZCLAS/ZCLAS_Assets/ZCLAS_Pictures/Geoserver1.png)
- Log into the server through PuTTY and navigate to the following folder: var/lib/tomcat9/webapps/geoserver/data/data
    - Upload the unzipped folder into the folder
- **OR** log into webmin and use 'File Manager' to navigate to the same folder: var/lib/tomcat9/webapps/geoserver/data/data
    - Then click 'File' and 'Upload to current directory'

![Geoserver2](/Pages/ZCLAS/ZCLAS_Assets/ZCLAS_Pictures/Geoserver2.png)
- In the pop up window, click **‘Directory Upload’** to upload the entire unzipped folder, otherwise the layer won’t be configured properly and will not display
    - Then drag and drop the unzipped folder and hit upload

![Geoserver3](/Pages/ZCLAS/ZCLAS_Assets/ZCLAS_Pictures/Geoserver3.png)
- You should see the unzipped folder in the file manager window

![Geoserver4](/Pages/ZCLAS/ZCLAS_Assets/ZCLAS_Pictures/Geoserver4.png)

## Configure Files in Geoserver
- Go to the geoserver and login with the proper credentials
    - 13.244.91.45:8080/geoserver/web
- We will be working with the zclas 'Workspace'

![Geoserver5](/Pages/ZCLAS/ZCLAS_Assets/ZCLAS_Pictures/Geoserver5.png)

### Publish New Layer from Store
- Go to 'Stores', then 'Add New Store' 

![Geoserver6](/Pages/ZCLAS/ZCLAS_Assets/ZCLAS_Pictures/Geoserver6.png)
- Then choose the type of vector or raster data that you uploaded to the server (most likely a shapefile)

![Geoserver7](/Pages/ZCLAS/ZCLAS_Assets/ZCLAS_Pictures/Geoserver7.png)
- Set the workspace to ‘zclas’, name the data source 
- Under ‘Connection Parameters’, click on ‘Browse…’

![Geoserver8](/Pages/ZCLAS/ZCLAS_Assets/ZCLAS_Pictures/Geoserver8.png)
- Navigate to the data/ folder, where we uploaded the shapefile, then click on the folder, and then the shapefile

![Geoserver9](/Pages/ZCLAS/ZCLAS_Assets/ZCLAS_Pictures/Geoserver9.png)

![Geoserver10](/Pages/ZCLAS/ZCLAS_Assets/ZCLAS_Pictures/Geoserver10.png)

![Geoserver11](/Pages/ZCLAS/ZCLAS_Assets/ZCLAS_Pictures/Geoserver11.png)
- Then you should see the shapefile in the shapefile location field

![Geoserver12](/Pages/ZCLAS/ZCLAS_Assets/ZCLAS_Pictures/Geoserver12.png)
- Hit ‘Save’, the ‘New Layer’ window will pop up, click on ‘Publish’

![Geoserver13](/Pages/ZCLAS/ZCLAS_Assets/ZCLAS_Pictures/Geoserver13.png)
- Under the data tab:
    - Check the name and title

![Geoserver14](/Pages/ZCLAS/ZCLAS_Assets/ZCLAS_Pictures/Geoserver14.png)
- Scroll down to ‘Coordinate Reference Systems’
    - Under 'Declared SRS', click ‘Find…’

![Geoserver15](/Pages/ZCLAS/ZCLAS_Assets/ZCLAS_Pictures/Geoserver15.png)
- We need to set the 'Declared SRS' to **4326 WGS 84**, search 4326, then click on 4326

![Geoserver16](/Pages/ZCLAS/ZCLAS_Assets/ZCLAS_Pictures/Geoserver16.png)
- Under 'SRS handling', choose **‘Reproject native to declared’**

![Geoserver17](/Pages/ZCLAS/ZCLAS_Assets/ZCLAS_Pictures/Geoserver17.png)
- Under ‘Bounding Boxes’, click ‘Compute from data’, and ‘Compute from native bounds’

![Geoserver18](/Pages/ZCLAS/ZCLAS_Assets/ZCLAS_Pictures/Geoserver18.png)
- Under 'Feature Type Details’, note which fields you might want to use as labels for styling, for example, ‘NAME’

![Geoserver19](/Pages/ZCLAS/ZCLAS_Assets/ZCLAS_Pictures/Geoserver19.png)
- Under the ‘Publishing’ tab
    - Set the 'Default Style', choose the default ‘polygon’ for now

![Geoserver20](/Pages/ZCLAS/ZCLAS_Assets/ZCLAS_Pictures/Geoserver20.png)
- Then scroll to the bottom and hit 'Save'

### Create Style for Layer
- We set the style for this layer to polygon, now we need to create a style for the layer that makes more sense
- Go to the 'Styles' page, and click on a pre-existing style to modify (so we don’t have to rewrite all the code)

![Geoserver21](/Pages/ZCLAS/ZCLAS_Assets/ZCLAS_Pictures/Geoserver21.png)
- Scroll down and copy the code

![Geoserver22](/Pages/ZCLAS/ZCLAS_Assets/ZCLAS_Pictures/Geoserver22.png)
- Then go back to the ‘Styles’ page and then click ‘Add a New Style’

![Geoserver23](/Pages/ZCLAS/ZCLAS_Assets/ZCLAS_Pictures/Geoserver23.png)
- Name the style
- Paste the code you copied before, we need to change two things: the color of the outline, and the field used to label
    - Edit the stroke color by editing the hex code

    ```
    <CssParameter name="stroke">#bc6c25</CssParameter>
    ```

![Geoserver24](/Pages/ZCLAS/ZCLAS_Assets/ZCLAS_Pictures/Geoserver24.png)

- Edit the label to the field you want to use to label the features

```
<ogc:PropertyName>NAME</ogc:PropertyName>
```

![Geoserver25](/Pages/ZCLAS/ZCLAS_Assets/ZCLAS_Pictures/Geoserver25.png)
- Then ‘Validate’, if everything looks good, click ‘Submit’

![Geoserver26](/Pages/ZCLAS/ZCLAS_Assets/ZCLAS_Pictures/Geoserver26.png)
- Then go to 'Layers' and click on the layer we just created

![Geoserver27](/Pages/ZCLAS/ZCLAS_Assets/ZCLAS_Pictures/Geoserver27.png)
- Go to the ‘Publishing’ tab and change the default style to the style we just created

![Geoserver28](/Pages/ZCLAS/ZCLAS_Assets/ZCLAS_Pictures/Geoserver28.png)
- Then hit 'Save'

### Preview Layer
- Go to ‘Layer Preview’
- Click on 'OpenLayers' on the layer

![Geoserver29](/Pages/ZCLAS/ZCLAS_Assets/ZCLAS_Pictures/Geoserver29.png)
- In the new window, check that everything looks correct, and how you want it

![Geoserver30](/Pages/ZCLAS/ZCLAS_Assets/ZCLAS_Pictures/Geoserver30.png)
- If you need to make any edits to the style, like changing the font size or color or label, go back to ‘Styles’ and edit the code for the corresponding layer

## Configure Geoserver in ZCLAS
- Go to [ZCLAS](http://13.244.91.45:8080/zclas/) an login as the superuser 
- Go to ‘Administration’ and ‘Map Layers’

![Geoserver31](/Pages/ZCLAS/ZCLAS_Assets/ZCLAS_Pictures/Geoserver31.png)
- Click on a preexisting layer, and copy the URL: http://13.244.91.45:8080/geoserver/zclas/wms?

![Geoserver32](/Pages/ZCLAS/ZCLAS_Assets/ZCLAS_Pictures/Geoserver32.png)
- Click 'Add'

![Geoserver33](/Pages/ZCLAS/ZCLAS_Assets/ZCLAS_Pictures/Geoserver33.png)
- Paste in the URL, the ‘Name’ needs to be the same as the name in the Geoserver, you can copy the name from the properties of the layer on the Geoserver interface

![Geoserver34](/Pages/ZCLAS/ZCLAS_Assets/ZCLAS_Pictures/Geoserver34.png)
- The title is what will appear in ZCLAS, layer type: WMS, hit ‘Save’

![Geoserver35](/Pages/ZCLAS/ZCLAS_Assets/ZCLAS_Pictures/Geoserver35.png)
- Go to 'Administration’ > ‘Reference Data’ > ‘Administrative Divisions’ > ‘Chiefdoms’

![Geoserver36](/Pages/ZCLAS/ZCLAS_Assets/ZCLAS_Pictures/Geoserver36.png)
- Choose the ‘Province’ > ‘Eastern’ 
- Click the edit pencil next to each Chiefdom where you wish to add the layer

![Geoserver37](/Pages/ZCLAS/ZCLAS_Assets/ZCLAS_Pictures/Geoserver37.png)
- Go to ‘Map Layers’, then click and highlight the layer you want to display, and click the right arrow

![Geoserver38](/Pages/ZCLAS/ZCLAS_Assets/ZCLAS_Pictures/Geoserver38.png)
- You should see the layer appear in the ‘Chiefdom Layers’ panel, then hit ‘Save’

![Geoserver39](/Pages/ZCLAS/ZCLAS_Assets/ZCLAS_Pictures/Geoserver39.png)
- You will need to add the layer to each Chiefdom individually, but if you view Zambia or a Province as a whole, you won’t see the layer listed multiple times
- Then you can go to ‘Map’ and see the layer you added

![Geoserver40](/Pages/ZCLAS/ZCLAS_Assets/ZCLAS_Pictures/Geoserver40.png)
