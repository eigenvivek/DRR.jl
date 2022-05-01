import Base: +, -, *, /, %, promote

"""
    Vec3
"""
struct Vec3{T<:Real}
    x::T
    y::T
    z::T
    Vec3{T}(x, y, z) where {T<:Real} = new(x, y, z)
end

Vec3(a::T) where {T<:Real} = Vec3{T}(a, a, a)
Vec3(x::T, y::T, z::T) where {T<:Real} = Vec3{T}(x, y, z)
Vec3(x::Real, y::Real, z::Real) = Vec3(promote(x, y, z)...)

+(p1::Vec3, p2::Vec3) = Vec3(p1.x + p2.x, p1.y + p2.y, p1.z + p2.y)
-(p1::Vec3, p2::Vec3) = Vec3(p1.x - p2.x, p1.y - p2.y, p1.x - p2.z)
*(t::Real, p::Vec3) = Vec3(t * p.x, t * p.y, t * p.z)
*(p::Vec3, t::Real) = *(t::Real, p::Vec3)
/(p::Vec3, t::Real) = Vec3(p.x / t, p.y / t, p.z / t)

@inline -(p::Vec3) = Vec3(-p.x, -p.y, -p.z)
@inline dot(p1::Vec3, p2::Vec3) = p1.x * p2.x + p1.y * p2.y + p1.z * p2.z
@inline l2norm(p::Vec3) = sqrt(dot(p, p))
@inline normalize(p::Vec3) = p / l2norm(p)

function promote(p1::Vec3, p2::Vec3)
    a, b, c, x, y, z = promote(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z)
    return Vec3(a, b, c), Vec3(x, y, z)
end


"""
    Ray
"""
# TODO: Is there some way to make the constructor do the normalization automatically???
struct Ray_{T<:Real}
    origin::Vec3{T}
    direction::Vec3{T}
    Ray_{T}(origin, direction) where {T<:Real} = new(origin, direction)
end

+(r1::Ray_, r2::Ray_) where {T<:Real} = Ray_{T}(r1.origin + r2.origin, r1.direction + r2.direction)

Ray_(origin::Vec3{T}, direction::Vec3{T}) where {T<:Real} = Ray_{T}(origin, direction)
Ray(origin, direction) = Ray_(promote(origin, normalize(direction))...)

@inline trace(t::Real; ray::Ray_) = ray.origin + ray.direction * t
