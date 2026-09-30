export namespace application2 {
	
	export class AnswerView {
	    selected_option?: string;
	    text: string;
	    has_images: boolean;
	    target_parts?: string[];
	
	    static createFrom(source: any = {}) {
	        return new AnswerView(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.selected_option = source["selected_option"];
	        this.text = source["text"];
	        this.has_images = source["has_images"];
	        this.target_parts = source["target_parts"];
	    }
	}
	export class EssayPartResultView {
	    label: string;
	    selected: boolean;
	    correct: boolean;
	    comment: string;
	
	    static createFrom(source: any = {}) {
	        return new EssayPartResultView(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.label = source["label"];
	        this.selected = source["selected"];
	        this.correct = source["correct"];
	        this.comment = source["comment"];
	    }
	}
	export class EssayPartView {
	    label: string;
	    question: string;
	    solution: string;
	    rubric: string;
	
	    static createFrom(source: any = {}) {
	        return new EssayPartView(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.label = source["label"];
	        this.question = source["question"];
	        this.solution = source["solution"];
	        this.rubric = source["rubric"];
	    }
	}
	export class OptionView {
	    label: string;
	    content: string;
	
	    static createFrom(source: any = {}) {
	        return new OptionView(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.label = source["label"];
	        this.content = source["content"];
	    }
	}
	export class ExerciseView {
	    type: string;
	    topic: string;
	    difficulty: string;
	    question: string;
	    diagram_type: string;
	    diagram_content: string;
	    options: OptionView[];
	    answer: string;
	    explanation: string;
	    parts: EssayPartView[];
	
	    static createFrom(source: any = {}) {
	        return new ExerciseView(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.type = source["type"];
	        this.topic = source["topic"];
	        this.difficulty = source["difficulty"];
	        this.question = source["question"];
	        this.diagram_type = source["diagram_type"];
	        this.diagram_content = source["diagram_content"];
	        this.options = this.convertValues(source["options"], OptionView);
	        this.answer = source["answer"];
	        this.explanation = source["explanation"];
	        this.parts = this.convertValues(source["parts"], EssayPartView);
	    }
	
		convertValues(a: any, classs: any, asMap: boolean = false): any {
		    if (!a) {
		        return a;
		    }
		    if (a.slice && a.map) {
		        return (a as any[]).map(elem => this.convertValues(elem, classs));
		    } else if ("object" === typeof a) {
		        if (asMap) {
		            for (const key of Object.keys(a)) {
		                a[key] = new classs(a[key]);
		            }
		            return a;
		        }
		        return new classs(a);
		    }
		    return a;
		}
	}
	export class AssignmentItemView {
	    id: number[];
	    exercise: ExerciseView;
	    answer?: AnswerView;
	    outcome: string;
	    is_evaluated: boolean;
	    is_valid: boolean;
	    invalid_reason: string;
	    output_result: string;
	    comment: string;
	    sub_items: EssayPartResultView[];
	
	    static createFrom(source: any = {}) {
	        return new AssignmentItemView(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.id = source["id"];
	        this.exercise = this.convertValues(source["exercise"], ExerciseView);
	        this.answer = this.convertValues(source["answer"], AnswerView);
	        this.outcome = source["outcome"];
	        this.is_evaluated = source["is_evaluated"];
	        this.is_valid = source["is_valid"];
	        this.invalid_reason = source["invalid_reason"];
	        this.output_result = source["output_result"];
	        this.comment = source["comment"];
	        this.sub_items = this.convertValues(source["sub_items"], EssayPartResultView);
	    }
	
		convertValues(a: any, classs: any, asMap: boolean = false): any {
		    if (!a) {
		        return a;
		    }
		    if (a.slice && a.map) {
		        return (a as any[]).map(elem => this.convertValues(elem, classs));
		    } else if ("object" === typeof a) {
		        if (asMap) {
		            for (const key of Object.keys(a)) {
		                a[key] = new classs(a[key]);
		            }
		            return a;
		        }
		        return new classs(a);
		    }
		    return a;
		}
	}
	export class AssignmentDetailView {
	    assignment_id: number[];
	    student_id: number[];
	    student_name: string;
	    title: string;
	    status: string;
	    // Go type: time
	    assigned_at: any;
	    purpose: string;
	    origin_mistake_id?: number[];
	    student_page_web_url: string;
	    teacher_page_web_url: string;
	    items: AssignmentItemView[];
	
	    static createFrom(source: any = {}) {
	        return new AssignmentDetailView(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.assignment_id = source["assignment_id"];
	        this.student_id = source["student_id"];
	        this.student_name = source["student_name"];
	        this.title = source["title"];
	        this.status = source["status"];
	        this.assigned_at = this.convertValues(source["assigned_at"], null);
	        this.purpose = source["purpose"];
	        this.origin_mistake_id = source["origin_mistake_id"];
	        this.student_page_web_url = source["student_page_web_url"];
	        this.teacher_page_web_url = source["teacher_page_web_url"];
	        this.items = this.convertValues(source["items"], AssignmentItemView);
	    }
	
		convertValues(a: any, classs: any, asMap: boolean = false): any {
		    if (!a) {
		        return a;
		    }
		    if (a.slice && a.map) {
		        return (a as any[]).map(elem => this.convertValues(elem, classs));
		    } else if ("object" === typeof a) {
		        if (asMap) {
		            for (const key of Object.keys(a)) {
		                a[key] = new classs(a[key]);
		            }
		            return a;
		        }
		        return new classs(a);
		    }
		    return a;
		}
	}
	
	export class AssignmentSummary {
	    assignment_id: number[];
	    student_id: number[];
	    student_name: string;
	    title: string;
	    status: string;
	    // Go type: time
	    assigned_at: any;
	    correct_count: number;
	    graded_count: number;
	    total_count: number;
	    student_page_web_url: string;
	    teacher_page_web_url: string;
	
	    static createFrom(source: any = {}) {
	        return new AssignmentSummary(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.assignment_id = source["assignment_id"];
	        this.student_id = source["student_id"];
	        this.student_name = source["student_name"];
	        this.title = source["title"];
	        this.status = source["status"];
	        this.assigned_at = this.convertValues(source["assigned_at"], null);
	        this.correct_count = source["correct_count"];
	        this.graded_count = source["graded_count"];
	        this.total_count = source["total_count"];
	        this.student_page_web_url = source["student_page_web_url"];
	        this.teacher_page_web_url = source["teacher_page_web_url"];
	    }
	
		convertValues(a: any, classs: any, asMap: boolean = false): any {
		    if (!a) {
		        return a;
		    }
		    if (a.slice && a.map) {
		        return (a as any[]).map(elem => this.convertValues(elem, classs));
		    } else if ("object" === typeof a) {
		        if (asMap) {
		            for (const key of Object.keys(a)) {
		                a[key] = new classs(a[key]);
		            }
		            return a;
		        }
		        return new classs(a);
		    }
		    return a;
		}
	}
	export class ClozePartView {
	    type: string;
	    value: string;
	
	    static createFrom(source: any = {}) {
	        return new ClozePartView(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.type = source["type"];
	        this.value = source["value"];
	    }
	}
	export class BlockView {
	    type: string;
	    body?: string;
	    ordered?: boolean;
	    items?: string[];
	    math?: string;
	    title?: string;
	    problem?: string;
	    solution?: string;
	    explanation?: string;
	    svg?: string;
	    caption?: string;
	    callout_kind?: string;
	    cloze_items?: ClozePartView[][];
	
	    static createFrom(source: any = {}) {
	        return new BlockView(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.type = source["type"];
	        this.body = source["body"];
	        this.ordered = source["ordered"];
	        this.items = source["items"];
	        this.math = source["math"];
	        this.title = source["title"];
	        this.problem = source["problem"];
	        this.solution = source["solution"];
	        this.explanation = source["explanation"];
	        this.svg = source["svg"];
	        this.caption = source["caption"];
	        this.callout_kind = source["callout_kind"];
	        this.cloze_items = this.convertValues(source["cloze_items"], ClozePartView);
	    }
	
		convertValues(a: any, classs: any, asMap: boolean = false): any {
		    if (!a) {
		        return a;
		    }
		    if (a.slice && a.map) {
		        return (a as any[]).map(elem => this.convertValues(elem, classs));
		    } else if ("object" === typeof a) {
		        if (asMap) {
		            for (const key of Object.keys(a)) {
		                a[key] = new classs(a[key]);
		            }
		            return a;
		        }
		        return new classs(a);
		    }
		    return a;
		}
	}
	
	export class StudentSummary {
	    id: number[];
	    name: string;
	    class: string;
	    meeting_code: string;
	    space_name: string;
	    cycle_start_day: number;
	    // Go type: time
	    created_at: any;
	    total_sessions: number;
	    total_duration_minutes: number;
	
	    static createFrom(source: any = {}) {
	        return new StudentSummary(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.id = source["id"];
	        this.name = source["name"];
	        this.class = source["class"];
	        this.meeting_code = source["meeting_code"];
	        this.space_name = source["space_name"];
	        this.cycle_start_day = source["cycle_start_day"];
	        this.created_at = this.convertValues(source["created_at"], null);
	        this.total_sessions = source["total_sessions"];
	        this.total_duration_minutes = source["total_duration_minutes"];
	    }
	
		convertValues(a: any, classs: any, asMap: boolean = false): any {
		    if (!a) {
		        return a;
		    }
		    if (a.slice && a.map) {
		        return (a as any[]).map(elem => this.convertValues(elem, classs));
		    } else if ("object" === typeof a) {
		        if (asMap) {
		            for (const key of Object.keys(a)) {
		                a[key] = new classs(a[key]);
		            }
		            return a;
		        }
		        return new classs(a);
		    }
		    return a;
		}
	}
	export class DashboardView {
	    total_students: number;
	    total_sessions: number;
	    total_duration_minutes: number;
	    students: StudentSummary[];
	
	    static createFrom(source: any = {}) {
	        return new DashboardView(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.total_students = source["total_students"];
	        this.total_sessions = source["total_sessions"];
	        this.total_duration_minutes = source["total_duration_minutes"];
	        this.students = this.convertValues(source["students"], StudentSummary);
	    }
	
		convertValues(a: any, classs: any, asMap: boolean = false): any {
		    if (!a) {
		        return a;
		    }
		    if (a.slice && a.map) {
		        return (a as any[]).map(elem => this.convertValues(elem, classs));
		    } else if ("object" === typeof a) {
		        if (asMap) {
		            for (const key of Object.keys(a)) {
		                a[key] = new classs(a[key]);
		            }
		            return a;
		        }
		        return new classs(a);
		    }
		    return a;
		}
	}
	export class Document {
	    id: number[];
	    file_name: string;
	    file_path: string;
	    page_count: number;
	    // Go type: time
	    created_at: any;
	
	    static createFrom(source: any = {}) {
	        return new Document(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.id = source["id"];
	        this.file_name = source["file_name"];
	        this.file_path = source["file_path"];
	        this.page_count = source["page_count"];
	        this.created_at = this.convertValues(source["created_at"], null);
	    }
	
		convertValues(a: any, classs: any, asMap: boolean = false): any {
		    if (!a) {
		        return a;
		    }
		    if (a.slice && a.map) {
		        return (a as any[]).map(elem => this.convertValues(elem, classs));
		    } else if ("object" === typeof a) {
		        if (asMap) {
		            for (const key of Object.keys(a)) {
		                a[key] = new classs(a[key]);
		            }
		            return a;
		        }
		        return new classs(a);
		    }
		    return a;
		}
	}
	export class TopicView {
	    title: string;
	    blocks: BlockView[];
	
	    static createFrom(source: any = {}) {
	        return new TopicView(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.title = source["title"];
	        this.blocks = this.convertValues(source["blocks"], BlockView);
	    }
	
		convertValues(a: any, classs: any, asMap: boolean = false): any {
		    if (!a) {
		        return a;
		    }
		    if (a.slice && a.map) {
		        return (a as any[]).map(elem => this.convertValues(elem, classs));
		    } else if ("object" === typeof a) {
		        if (asMap) {
		            for (const key of Object.keys(a)) {
		                a[key] = new classs(a[key]);
		            }
		            return a;
		        }
		        return new classs(a);
		    }
		    return a;
		}
	}
	export class SectionView {
	    title: string;
	    topics: TopicView[];
	
	    static createFrom(source: any = {}) {
	        return new SectionView(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.title = source["title"];
	        this.topics = this.convertValues(source["topics"], TopicView);
	    }
	
		convertValues(a: any, classs: any, asMap: boolean = false): any {
		    if (!a) {
		        return a;
		    }
		    if (a.slice && a.map) {
		        return (a as any[]).map(elem => this.convertValues(elem, classs));
		    } else if ("object" === typeof a) {
		        if (asMap) {
		            for (const key of Object.keys(a)) {
		                a[key] = new classs(a[key]);
		            }
		            return a;
		        }
		        return new classs(a);
		    }
		    return a;
		}
	}
	export class LessonView {
	    id: number[];
	    title: string;
	    overview: string;
	    sections: SectionView[];
	    exercises: ExerciseView[];
	
	    static createFrom(source: any = {}) {
	        return new LessonView(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.id = source["id"];
	        this.title = source["title"];
	        this.overview = source["overview"];
	        this.sections = this.convertValues(source["sections"], SectionView);
	        this.exercises = this.convertValues(source["exercises"], ExerciseView);
	    }
	
		convertValues(a: any, classs: any, asMap: boolean = false): any {
		    if (!a) {
		        return a;
		    }
		    if (a.slice && a.map) {
		        return (a as any[]).map(elem => this.convertValues(elem, classs));
		    } else if ("object" === typeof a) {
		        if (asMap) {
		            for (const key of Object.keys(a)) {
		                a[key] = new classs(a[key]);
		            }
		            return a;
		        }
		        return new classs(a);
		    }
		    return a;
		}
	}
	export class DraftView {
	    id: number[];
	    title: string;
	    model: string;
	    custom_prompt: string;
	    status: string;
	    source_type: string;
	    source_url: string;
	    // Go type: time
	    created_at: any;
	    // Go type: time
	    updated_at?: any;
	    error_message: string;
	    lesson_data?: LessonView;
	
	    static createFrom(source: any = {}) {
	        return new DraftView(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.id = source["id"];
	        this.title = source["title"];
	        this.model = source["model"];
	        this.custom_prompt = source["custom_prompt"];
	        this.status = source["status"];
	        this.source_type = source["source_type"];
	        this.source_url = source["source_url"];
	        this.created_at = this.convertValues(source["created_at"], null);
	        this.updated_at = this.convertValues(source["updated_at"], null);
	        this.error_message = source["error_message"];
	        this.lesson_data = this.convertValues(source["lesson_data"], LessonView);
	    }
	
		convertValues(a: any, classs: any, asMap: boolean = false): any {
		    if (!a) {
		        return a;
		    }
		    if (a.slice && a.map) {
		        return (a as any[]).map(elem => this.convertValues(elem, classs));
		    } else if ("object" === typeof a) {
		        if (asMap) {
		            for (const key of Object.keys(a)) {
		                a[key] = new classs(a[key]);
		            }
		            return a;
		        }
		        return new classs(a);
		    }
		    return a;
		}
	}
	
	
	
	
	export class ParticipantView {
	    name: string;
	    // Go type: time
	    first_joined_at: any;
	    // Go type: time
	    last_left_at: any;
	    duration: number;
	
	    static createFrom(source: any = {}) {
	        return new ParticipantView(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.name = source["name"];
	        this.first_joined_at = this.convertValues(source["first_joined_at"], null);
	        this.last_left_at = this.convertValues(source["last_left_at"], null);
	        this.duration = source["duration"];
	    }
	
		convertValues(a: any, classs: any, asMap: boolean = false): any {
		    if (!a) {
		        return a;
		    }
		    if (a.slice && a.map) {
		        return (a as any[]).map(elem => this.convertValues(elem, classs));
		    } else if ("object" === typeof a) {
		        if (asMap) {
		            for (const key of Object.keys(a)) {
		                a[key] = new classs(a[key]);
		            }
		            return a;
		        }
		        return new classs(a);
		    }
		    return a;
		}
	}
	export class MeetingView {
	    id: number[];
	    // Go type: time
	    started_at: any;
	    // Go type: time
	    ended_at: any;
	    participants: ParticipantView[];
	
	    static createFrom(source: any = {}) {
	        return new MeetingView(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.id = source["id"];
	        this.started_at = this.convertValues(source["started_at"], null);
	        this.ended_at = this.convertValues(source["ended_at"], null);
	        this.participants = this.convertValues(source["participants"], ParticipantView);
	    }
	
		convertValues(a: any, classs: any, asMap: boolean = false): any {
		    if (!a) {
		        return a;
		    }
		    if (a.slice && a.map) {
		        return (a as any[]).map(elem => this.convertValues(elem, classs));
		    } else if ("object" === typeof a) {
		        if (asMap) {
		            for (const key of Object.keys(a)) {
		                a[key] = new classs(a[key]);
		            }
		            return a;
		        }
		        return new classs(a);
		    }
		    return a;
		}
	}
	export class MistakeNodeView {
	    id: number[];
	    topic: string;
	    reason: string;
	    status: string;
	    // Go type: time
	    created_at: any;
	    // Go type: time
	    resolved_at?: any;
	    source_item_id: number[];
	    source_assignment_id?: number[];
	    children: MistakeNodeView[];
	
	    static createFrom(source: any = {}) {
	        return new MistakeNodeView(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.id = source["id"];
	        this.topic = source["topic"];
	        this.reason = source["reason"];
	        this.status = source["status"];
	        this.created_at = this.convertValues(source["created_at"], null);
	        this.resolved_at = this.convertValues(source["resolved_at"], null);
	        this.source_item_id = source["source_item_id"];
	        this.source_assignment_id = source["source_assignment_id"];
	        this.children = this.convertValues(source["children"], MistakeNodeView);
	    }
	
		convertValues(a: any, classs: any, asMap: boolean = false): any {
		    if (!a) {
		        return a;
		    }
		    if (a.slice && a.map) {
		        return (a as any[]).map(elem => this.convertValues(elem, classs));
		    } else if ("object" === typeof a) {
		        if (asMap) {
		            for (const key of Object.keys(a)) {
		                a[key] = new classs(a[key]);
		            }
		            return a;
		        }
		        return new classs(a);
		    }
		    return a;
		}
	}
	
	
	export class PublishingNotebook {
	    name: string;
	    sections: string[];
	
	    static createFrom(source: any = {}) {
	        return new PublishingNotebook(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.name = source["name"];
	        this.sections = source["sections"];
	    }
	}
	export class PublishingTargets {
	    student: PublishingNotebook;
	    teacher: PublishingNotebook;
	
	    static createFrom(source: any = {}) {
	        return new PublishingTargets(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.student = this.convertValues(source["student"], PublishingNotebook);
	        this.teacher = this.convertValues(source["teacher"], PublishingNotebook);
	    }
	
		convertValues(a: any, classs: any, asMap: boolean = false): any {
		    if (!a) {
		        return a;
		    }
		    if (a.slice && a.map) {
		        return (a as any[]).map(elem => this.convertValues(elem, classs));
		    } else if ("object" === typeof a) {
		        if (asMap) {
		            for (const key of Object.keys(a)) {
		                a[key] = new classs(a[key]);
		            }
		            return a;
		        }
		        return new classs(a);
		    }
		    return a;
		}
	}
	
	export class StudentView {
	    id: number[];
	    name: string;
	    class: string;
	    meeting_code: string;
	    space_name: string;
	    cycle_start_day: number;
	    // Go type: time
	    created_at: any;
	
	    static createFrom(source: any = {}) {
	        return new StudentView(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.id = source["id"];
	        this.name = source["name"];
	        this.class = source["class"];
	        this.meeting_code = source["meeting_code"];
	        this.space_name = source["space_name"];
	        this.cycle_start_day = source["cycle_start_day"];
	        this.created_at = this.convertValues(source["created_at"], null);
	    }
	
		convertValues(a: any, classs: any, asMap: boolean = false): any {
		    if (!a) {
		        return a;
		    }
		    if (a.slice && a.map) {
		        return (a as any[]).map(elem => this.convertValues(elem, classs));
		    } else if ("object" === typeof a) {
		        if (asMap) {
		            for (const key of Object.keys(a)) {
		                a[key] = new classs(a[key]);
		            }
		            return a;
		        }
		        return new classs(a);
		    }
		    return a;
		}
	}
	export class StudentDetailView {
	    student: StudentView;
	    total_sessions: number;
	    total_duration_minutes: number;
	    meetings: MeetingView[];
	
	    static createFrom(source: any = {}) {
	        return new StudentDetailView(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.student = this.convertValues(source["student"], StudentView);
	        this.total_sessions = source["total_sessions"];
	        this.total_duration_minutes = source["total_duration_minutes"];
	        this.meetings = this.convertValues(source["meetings"], MeetingView);
	    }
	
		convertValues(a: any, classs: any, asMap: boolean = false): any {
		    if (!a) {
		        return a;
		    }
		    if (a.slice && a.map) {
		        return (a as any[]).map(elem => this.convertValues(elem, classs));
		    } else if ("object" === typeof a) {
		        if (asMap) {
		            for (const key of Object.keys(a)) {
		                a[key] = new classs(a[key]);
		            }
		            return a;
		        }
		        return new classs(a);
		    }
		    return a;
		}
	}
	export class StudentMistakeGroup {
	    student_id: number[];
	    student_name: string;
	    mistakes: MistakeNodeView[];
	
	    static createFrom(source: any = {}) {
	        return new StudentMistakeGroup(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.student_id = source["student_id"];
	        this.student_name = source["student_name"];
	        this.mistakes = this.convertValues(source["mistakes"], MistakeNodeView);
	    }
	
		convertValues(a: any, classs: any, asMap: boolean = false): any {
		    if (!a) {
		        return a;
		    }
		    if (a.slice && a.map) {
		        return (a as any[]).map(elem => this.convertValues(elem, classs));
		    } else if ("object" === typeof a) {
		        if (asMap) {
		            for (const key of Object.keys(a)) {
		                a[key] = new classs(a[key]);
		            }
		            return a;
		        }
		        return new classs(a);
		    }
		    return a;
		}
	}
	
	

}

export namespace wails {
	
	export class Application2Services {
	    // Go type: application2
	    Queries?: any;
	    // Go type: application2
	    SyncMeetings?: any;
	    // Go type: application2
	    GenerateLesson?: any;
	    // Go type: application2
	    GenerateRemediationLesson?: any;
	    // Go type: application2
	    UpdateLessonDraft?: any;
	    // Go type: application2
	    UpdateStudent?: any;
	    // Go type: application2
	    PreparePublishingTargets?: any;
	    // Go type: application2
	    AssignLesson?: any;
	    // Go type: application2
	    GradeAssignment?: any;
	    Lessons: any;
	    Assignments: any;
	    Workspace: any;
	    StorageRoot: string;
	    // Go type: application2
	    UploadHandler?: any;
	    // Go type: application2
	    ExtractHandler?: any;
	    DocRepo: any;
	
	    static createFrom(source: any = {}) {
	        return new Application2Services(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.Queries = this.convertValues(source["Queries"], null);
	        this.SyncMeetings = this.convertValues(source["SyncMeetings"], null);
	        this.GenerateLesson = this.convertValues(source["GenerateLesson"], null);
	        this.GenerateRemediationLesson = this.convertValues(source["GenerateRemediationLesson"], null);
	        this.UpdateLessonDraft = this.convertValues(source["UpdateLessonDraft"], null);
	        this.UpdateStudent = this.convertValues(source["UpdateStudent"], null);
	        this.PreparePublishingTargets = this.convertValues(source["PreparePublishingTargets"], null);
	        this.AssignLesson = this.convertValues(source["AssignLesson"], null);
	        this.GradeAssignment = this.convertValues(source["GradeAssignment"], null);
	        this.Lessons = source["Lessons"];
	        this.Assignments = source["Assignments"];
	        this.Workspace = source["Workspace"];
	        this.StorageRoot = source["StorageRoot"];
	        this.UploadHandler = this.convertValues(source["UploadHandler"], null);
	        this.ExtractHandler = this.convertValues(source["ExtractHandler"], null);
	        this.DocRepo = source["DocRepo"];
	    }
	
		convertValues(a: any, classs: any, asMap: boolean = false): any {
		    if (!a) {
		        return a;
		    }
		    if (a.slice && a.map) {
		        return (a as any[]).map(elem => this.convertValues(elem, classs));
		    } else if ("object" === typeof a) {
		        if (asMap) {
		            for (const key of Object.keys(a)) {
		                a[key] = new classs(a[key]);
		            }
		            return a;
		        }
		        return new classs(a);
		    }
		    return a;
		}
	}
	export class DashboardRequest {
	    search_name: string;
	    // Go type: time
	    from_date: any;
	    // Go type: time
	    to_date: any;
	    min_duration_minutes: number;
	
	    static createFrom(source: any = {}) {
	        return new DashboardRequest(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.search_name = source["search_name"];
	        this.from_date = this.convertValues(source["from_date"], null);
	        this.to_date = this.convertValues(source["to_date"], null);
	        this.min_duration_minutes = source["min_duration_minutes"];
	    }
	
		convertValues(a: any, classs: any, asMap: boolean = false): any {
		    if (!a) {
		        return a;
		    }
		    if (a.slice && a.map) {
		        return (a as any[]).map(elem => this.convertValues(elem, classs));
		    } else if ("object" === typeof a) {
		        if (asMap) {
		            for (const key of Object.keys(a)) {
		                a[key] = new classs(a[key]);
		            }
		            return a;
		        }
		        return new classs(a);
		    }
		    return a;
		}
	}
	export class GenerateLessonRequest {
	    title: string;
	    model: string;
	    prompt: string;
	    url: string;
	    material: string;
	    document_id: string;
	    pages: number[];
	
	    static createFrom(source: any = {}) {
	        return new GenerateLessonRequest(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.title = source["title"];
	        this.model = source["model"];
	        this.prompt = source["prompt"];
	        this.url = source["url"];
	        this.material = source["material"];
	        this.document_id = source["document_id"];
	        this.pages = source["pages"];
	    }
	}
	export class GradeRequest {
	    assignment_id: string;
	    item_ids: string[];
	    prompt: string;
	    model: string;
	
	    static createFrom(source: any = {}) {
	        return new GradeRequest(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.assignment_id = source["assignment_id"];
	        this.item_ids = source["item_ids"];
	        this.prompt = source["prompt"];
	        this.model = source["model"];
	    }
	}
	export class ModelView {
	    id: string;
	    display_name: string;
	    description: string;
	
	    static createFrom(source: any = {}) {
	        return new ModelView(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.id = source["id"];
	        this.display_name = source["display_name"];
	        this.description = source["description"];
	    }
	}
	export class PreparePublishingRequest {
	    student_id: string;
	
	    static createFrom(source: any = {}) {
	        return new PreparePublishingRequest(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.student_id = source["student_id"];
	    }
	}
	export class PublishLessonRequest {
	    lesson_id: string;
	    student_id: string;
	    page_name: string;
	    student_chapter_name: string;
	    teacher_chapter_name: string;
	
	    static createFrom(source: any = {}) {
	        return new PublishLessonRequest(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.lesson_id = source["lesson_id"];
	        this.student_id = source["student_id"];
	        this.page_name = source["page_name"];
	        this.student_chapter_name = source["student_chapter_name"];
	        this.teacher_chapter_name = source["teacher_chapter_name"];
	    }
	}
	export class RemediationRequest {
	    student_id: string;
	    mistake_id: string;
	    title: string;
	    model: string;
	    prompt: string;
	
	    static createFrom(source: any = {}) {
	        return new RemediationRequest(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.student_id = source["student_id"];
	        this.mistake_id = source["mistake_id"];
	        this.title = source["title"];
	        this.model = source["model"];
	        this.prompt = source["prompt"];
	    }
	}
	export class StudentDetailRequest {
	    student_id: string;
	    // Go type: time
	    from_date: any;
	    // Go type: time
	    to_date: any;
	    min_duration_minutes: number;
	
	    static createFrom(source: any = {}) {
	        return new StudentDetailRequest(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.student_id = source["student_id"];
	        this.from_date = this.convertValues(source["from_date"], null);
	        this.to_date = this.convertValues(source["to_date"], null);
	        this.min_duration_minutes = source["min_duration_minutes"];
	    }
	
		convertValues(a: any, classs: any, asMap: boolean = false): any {
		    if (!a) {
		        return a;
		    }
		    if (a.slice && a.map) {
		        return (a as any[]).map(elem => this.convertValues(elem, classs));
		    } else if ("object" === typeof a) {
		        if (asMap) {
		            for (const key of Object.keys(a)) {
		                a[key] = new classs(a[key]);
		            }
		            return a;
		        }
		        return new classs(a);
		    }
		    return a;
		}
	}
	export class UpdateStudentRequest {
	    student_id: string;
	    name: string;
	    start_cycle_day: number;
	
	    static createFrom(source: any = {}) {
	        return new UpdateStudentRequest(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.student_id = source["student_id"];
	        this.name = source["name"];
	        this.start_cycle_day = source["start_cycle_day"];
	    }
	}

}

