using DICOM


function read_dicom(path::String)

    dcm_data_array = dcmdir_parse(path)

    # Get the dimensions of the volume
    n_dcm = length(dcm_data_array)
    nx, ny = size(dcm_data_array[1][tag"PixelData"])
    volume = Array{Int16}(undef, (n_dcm, nx, ny))

    # x and y pixel spacing 
    x_spacing, y_spacing = dcm_data_array[1][tag"PixelSpacing"]

    # find moving axis
    firstCoord = dcm_data_array[n_dcm][tag"ImagePositionPatient"]
    secondCoord = dcm_data_array[n_dcm - 1][tag"ImagePositionPatient"]
    gapAxis = findall( x -> x == 0, firstCoord .≈ secondCoord )[1]

    gapCoords = Array{Float64}(undef,n_dcm)
    z_spacing = Array{Float64}(undef,n_dcm-1)

    # first slice of volume 
    slice = dcm_data_array[end][tag"PixelData"][end:-1:1, :]
    volume[1, :, :] = slice
    gapCoords[1] = dcm_data_array[end][tag"ImagePositionPatient"][gapAxis] 

    # Create the volume
    for i in 2:n_dcm
        # A little slice reordering is necessary to get this looking right
        slice = dcm_data_array[end-i+1][tag"PixelData"][end:-1:1, :]
        volume[i, :, :] = slice

        # find z spacing
        gapCoords[i] = dcm_data_array[end-i+1][tag"ImagePositionPatient"][gapAxis] 
        z_spacing[i-1] = gapCoords[i] - gapCoords[i-1]

    end

    # check if z_spacing is equal
    if sum(.!(z_spacing[1] .≈ z_spacing) == 0)
        z_spacing = z_spacing[1] # if same, return single value for z
    end

    return volume, x_spacing, y_spacing, z_spacing

end