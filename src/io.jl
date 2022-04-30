using DICOM


function read_dicom(path::String)

    dcm_data_array = dcmdir_parse(path)

    # Get the dimensions of the volume
    n_dcm = length(dcm_data_array)
    nx, ny = size(dcm_data_array[1][tag"PixelData"])
    volume = Array{Int16}(undef, (n_dcm, nx, ny))

    # Create the volume
    for i in 1:n_dcm
        # A little slice reordering is necessary to get this looking right
        slice = dcm_data_array[end-i+1][tag"PixelData"][end:-1:1, :]
        volume[i, :, :] = slice
    end

    return volume

end