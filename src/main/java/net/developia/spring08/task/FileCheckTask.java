package net.developia.spring08.task;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import lombok.Setter;
import lombok.extern.log4j.Log4j;
import net.developia.spring08.dao.AttachFileDAO;
import net.developia.spring08.dto.AttachFileDTO;

// 사용하지 않는 파일 삭제
@Log4j
@Component
public class FileCheckTask {
	
	@Setter(onMethod_ = {@Autowired})
	private AttachFileDAO attachFileDAO;
	
	@Scheduled(cron=" 0 * * * * *")
	public void check() throws Exception{
		log.warn("File Check Task run ........");
	}
	
	// 어제 날짜 폴더명
	private String getFolderYesterDay() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.DATE, -1);
		String str = sdf.format(cal.getTime());
		return str.replace("-", File.separator);
	}
	
	@Scheduled(cron = "0 0 2 * * *")
	public void checkFiles() throws Exception{
		log.warn("file check : " + new Date());
		// 파일 리스트 받아오기
		List<AttachFileDTO> fileList = attachFileDAO.getOldFiles();
		
		//DB 파일 리스트와 디렉토리 파일 리스트 비교
		List<Path> fileListPaths = fileList.stream()
				.map(dto -> Paths.get("C:\\upload", dto.getUploadPath(), dto.getUuid()+"_"+dto.getFileName()))
				.collect(Collectors.toList());
		
		// 이미지 섬네일 파일 처리
		fileList.stream().filter(dto -> dto.getFileType() == 1)
		.map(dto->Paths.get("C:\\upload", dto.getUploadPath(), "s_"+dto.getUuid()+"_"+dto.getFileName()))
		.forEach(p->fileListPaths.add(p));
		
		fileListPaths.forEach(p->log.warn(p));
		
		// 제거할 파일 선택
		File targetDir = Paths.get("C:\\upload", getFolderYesterDay()).toFile();
		File[] removeFiles = targetDir.listFiles(file->fileListPaths.contains(file.toPath()) == false);
		
		// 파일 제거
		for(File file : removeFiles) {
			log.warn(file.getAbsolutePath());
			file.delete();
		}
	}
}
