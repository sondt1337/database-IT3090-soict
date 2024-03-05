--1.
CREATE TABLE NHANVIEN_HANT (
    MANV_0298 VARCHAR(10) PRIMARY KEY,
    HOTEN_0298 NVARCHAR(30) NOT NULL,
    NHIEMVU_0298 NVARCHAR(30) NOT NULL,
    LUONGGIO_0298 INT NOT NULL,
)

CREATE TABLE MAYBAY_HANT (
    MAMB_0298 VARCHAR(10) PRIMARY KEY,
    TENMB_0298 NVARCHAR(30) NOT NULL,
    SOKHACH_0298 INT NOT NULL,
)

CREATE TABLE CHUYENBAY_HANT (
    MACB_0298 VARCHAR(10) PRIMARY KEY,
    MAMB_0298 VARCHAR(10) NOT NULL,
    NOIXP_0298 NVARCHAR(30) NOT NULL,
    NOIDEN_0298 NVARCHAR(30) NOT NULL,
    NGAYBAY_0298 DATE NOT NULL,
    SOKHACH_0298 INT NOT NULL,
    SOGIOBAY_0298 REAL NOT NULL,
    FOREIGN KEY (MAMB_0298) REFERENCES MAYBAY_HANT(MAMB_0298)
)

CREATE TABLE CHITIET_CHUYENBAY_HANT (
    MACB_0298 VARCHAR(10) NOT NULL,
    MANV_0298 VARCHAR(10) NOT NULL,
    FOREIGN KEY (MACB_0298) REFERENCES CHUYENBAY_HANT(MACB_0298),
    FOREIGN KEY (MANV_0298) REFERENCES NHANVIEN_HANT(MANV_0298),
    PRIMARY KEY (MACB_0298, MANV_0298)
)
--2.
--2.1--
ALTER TABLE CHUYENBAY_HANT
ADD CONSTRAINT CHK_SOKHACH_0298 
CHECK (NOIXP_0298 <> NOIDEN_0298)

--2.2--
ALTER TABLE MAYBAY_HANT 
ADD CONSTRAINT CHK_SOKHACH_0298
CHECK (SOKHACH_0298 >= 350)

--2.3--
ALTER TABLE NHANVIEN_HANT
ADD CONSTRAINT CHK_NHIEMVU_0298
CHECK (NHIEMVU_0298 IN (N'Cơ trưởng', N'Phó cơ trưởng', N'Tiếp viên')
AND LUONGGIO_0298 >= 100)

--3.
INSERT INTO NHANVIEN_HANT VALUES 
('NV0001', N'Hoàng Long', N'Cơ trưởng', 150),
('NV0002', N'Trần Nam Anh', N'Phó cơ trưởng', 125),
('NV0003', N'Lê Tiến Đạt', N'Tiếp viên', 100),
('NV0004', N'Nguyễn Bình An', N'Cơ trưởng', 150),
('NV0005', N'Đinh Văn Minh', N'Phó cơ trưởng', 125),
('NV0006', N'Ngô Lệ Bình', N'Tiếp viên', 100),
('NV0007', N'Vũ Tuấn Anh', N'Tiếp viên', 100)

INSERT INTO MAYBAY_HANT VALUES 
('BL750', N'Airbus A320', 450),
('QH228', N'Airbus A321', 350),
('VJ144', N'Boing A320', 450),
('VJ146', N'Boeing 146', 540),
('VN216', N'Airbus A350', 500),
('VN238', N'Boing A321', 450)

INSERT INTO CHUYENBAY_HANT VALUES 
('CB0001', 'BL750', N'TP HCM', N'Hà Nội', '2021-10-10', 340, 5.5),
('CB0002', 'QH228', N'Hà Nội', N'Nha Trang', '2021-12-10', 300, 4.5),
('CB0003', 'VJ144', N'TP HCM', N'Đà Nẵng', '2021-11-10', 400, 2),
('CB0004', 'VN216', N'Hà Nội', N'Đà Nẵng', '2021-10-15', 350, 3.5),
('CB0005', 'VN238', N'TP HCM', N'Hà Nội', '2021-10-20', 350, 5.5)

INSERT INTO CHITIET_CHUYENBAY_HANT VALUES 
('CB0001', 'NV0001'),
('CB0001', 'NV0002'),
('CB0001', 'NV0003'),
('CB0001', 'NV0006'),
('CB0002', 'NV0004'),
('CB0002', 'NV0005'),
('CB0002', 'NV0006'),
('CB0002', 'NV0007'),
('CB0003', 'NV0001'),
('CB0003', 'NV0002'),
('CB0003', 'NV0003'),
('CB0003', 'NV0007'),
('CB0004', 'NV0001'),
('CB0004', 'NV0002'),
('CB0004', 'NV0006'),
('CB0004', 'NV0007'),
('CB0005', 'NV0002'),
('CB0005', 'NV0003'),
('CB0005', 'NV0004'),
('CB0005', 'NV0005'),
('CB0005', 'NV0006')

--4.
--4.1--
SELECT nv.MANV_0298, nv.HOTEN_0298, nv.NHIEMVU_0298, COUNT(ct.MACB_0298) AS [Số chuyến bay], SUM(cb.SOKHACH_0298) AS [Số khách]
FROM NHANVIEN_HANT nv, CHITIET_CHUYENBAY_HANT ct, CHUYENBAY_HANT cb, MAYBAY_HANT mb
WHERE nv.MANV_0298 = ct.MANV_0298 AND ct.MACB_0298 = cb.MACB_0298 AND cb.MAMB_0298 = mb.MAMB_0298
AND mb.TENMB_0298 LIKE N'%Airbus%'
AND (YEAR(cb.NGAYBAY_0298) = 2021 AND MONTH(cb.NGAYBAY_0298) = 10)
GROUP BY nv.MANV_0298, nv.HOTEN_0298, nv.NHIEMVU_0298

--4.2--
SELECT mb.MAMB_0298, mb.TENMB_0298, mb.SOKHACH_0298 AS [Số khách chuẩn], cb.SOKHACH_0298 AS [Số khách thực tế],
SUM(nv.LUONGGIO_0298 * cb.SOGIOBAY_0298) AS [Tiền công]
FROM MAYBAY_HANT mb, CHUYENBAY_HANT cb, NHANVIEN_HANT nv, CHITIET_CHUYENBAY_HANT ct
WHERE mb.MAMB_0298 = cb.MAMB_0298 AND cb.MACB_0298 = ct.MACB_0298 AND ct.MANV_0298 = nv.MANV_0298
AND (YEAR(cb.NGAYBAY_0298) = 2021 AND (MONTH(cb.NGAYBAY_0298) = 10 OR MONTH(cb.NGAYBAY_0298) = 11))
GROUP BY cb.MACB_0298, mb.MAMB_0298, mb.TENMB_0298, mb.SOKHACH_0298, cb.SOKHACH_0298
HAVING SUM(nv.LUONGGIO_0298 * cb.SOGIOBAY_0298) >= ALL(
    SELECT SUM(nv.LUONGGIO_0298 * cb.SOGIOBAY_0298)
    FROM MAYBAY_HANT mb, CHUYENBAY_HANT cb, NHANVIEN_HANT nv, CHITIET_CHUYENBAY_HANT ct
    WHERE mb.MAMB_0298 = cb.MAMB_0298 AND cb.MACB_0298 = ct.MACB_0298 AND ct.MANV_0298 = nv.MANV_0298
    GROUP BY cb.MACB_0298
)

--4.3--
SELECT nv.MANV_0298, nv.HOTEN_0298, COUNT(ct.MACB_0298) AS [Số chuyến bay], 
SUM(cb.SOGIOBAY_0298) AS [Số giờ bay], SUM(nv.LUONGGIO_0298 * cb.SOGIOBAY_0298) AS [Tiền công]
FROM NHANVIEN_HANT nv, CHITIET_CHUYENBAY_HANT ct, CHUYENBAY_HANT cb
WHERE nv.MANV_0298 = ct.MANV_0298 AND ct.MACB_0298 = cb.MACB_0298 
AND YEAR(cb.NGAYBAY_0298) = 2021 
GROUP BY nv.MANV_0298, nv.HOTEN_0298
HAVING COUNT(ct.MACB_0298) >= 3

--5.
--5.1--
GO
CREATE PROCEDURE p1_0298
AS
BEGIN
    SELECT *
    FROM MAYBAY_HANT
    WHERE TENMB_0298 LIKE N'Airbus%'
END;
--exec p1_0298
EXEC p1_0298

--5.2--
GO
CREATE PROCEDURE p2_0298
AS
BEGIN
    INSERT INTO MAYBAY_HANT VALUES ('VN12345', N'Vins 1236', 450)
END;
--exec p2_0298
EXEC p2_0298

--5.3--
GO
CREATE PROCEDURE p3_0298
AS
BEGIN
    SELECT mb.MAMB_0298, mb.TENMB_0298, ct.MANV_0298 , nv.HOTEN_0298, nv.NHIEMVU_0298, 
    SUM(cb.SOGIOBAY_0298) AS [Số giờ bay], SUM(nv.LUONGGIO_0298 * cb.SOGIOBAY_0298) AS [Tiền công]
    FROM MAYBAY_HANT mb, CHUYENBAY_HANT cb, CHITIET_CHUYENBAY_HANT ct, NHANVIEN_HANT nv
    WHERE mb.MAMB_0298 = cb.MAMB_0298 AND cb.MACB_0298 = ct.MACB_0298 AND ct.MANV_0298 = nv.MANV_0298
    AND mb.TENMB_0298 LIKE N'Airbus%'
    GROUP BY mb.MAMB_0298, cb.MACB_0298, mb.TENMB_0298, ct.MANV_0298, nv.HOTEN_0298, nv.NHIEMVU_0298
END;
--exec p3_0298
EXEC p3_0298
