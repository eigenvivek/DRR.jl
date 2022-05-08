using DICOM
using Interpolations


function read_dicom(path::String)

    dcm_data_array = dcmdir_parse(path)

    # Get the dimensions of the volume
    n_dcm = length(dcm_data_array)
    nx, ny = size(dcm_data_array[1][tag"PixelData"])
    vol_raw = Array{Int16}(undef, (n_dcm, nx, ny))

    # for recording changing coordinate of slices
    gapCoords = Array{Float64}(undef,n_dcm) 

    # find the moving axis 
    firstCoord = dcm_data_array[n_dcm][tag"ImagePositionPatient"]
    secondCoord = dcm_data_array[n_dcm - 1][tag"ImagePositionPatient"]
    gapAxis = findall( x -> x == 0, firstCoord .≈ secondCoord )[1]

    # Create the volume
    for i in 1:n_dcm
        # A little slice reordering is necessary to get this looking right
        slice = dcm_data_array[end-i+1][tag"PixelData"][end:-1:1, :]
        pat_coords = dcm_data_array[end-i+1][tag"ImagePositionPatient"]
        gapCoords[i] = pat_coords[gapAxis]
        vol_raw[i, :, :] = slice
    end

    # find spacing between x pixels
    pxSpacing = dcm_data_array[1][tag"PixelSpacing"][1]

    # define linear space that will be used for interpolation. If x spacing = y spacing, the voxels will be cubes.  
    vox_space = minimum(gapCoords):pxSpacing:maximum(gapCoords) 

    volume = Array{Int16}(undef, (length(vox_space), nx, ny))
    for x in 1:nx, y in 1:ny
        data_col = vol_raw[:, x, y]
        # interpolate column of data and redefine to voxel space
        interpol = LinearInterpolation(gapCoords, data_col)
        newcol = interpol(vox_space)
        volume[:, x, y] = round.(newcol)
    end

    return volume

end